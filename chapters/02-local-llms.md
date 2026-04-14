```{=latex}
\clearpage
```

# Running LLMs Locally

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,trim=0 500 0 500,clip]{assets/images/chapter-02-local-llms.png}
\end{center}
```

This chapter covers the hardware and runtime constraints behind local inference. It focuses on the tradeoffs that determine whether a model is practical on your machines.

## Why Run Models Locally

Teams run language models locally for four recurring reasons: privacy, cost control, latency control, and deployment flexibility. A local deployment can keep sensitive prompts and source documents inside a trusted environment, which is often a hard requirement in regulated or security-conscious settings.

Local inference also changes the cost profile. Instead of paying per request to a hosted vendor, teams pay in hardware acquisition, utilization management, and operational complexity. That trade is attractive when workloads are steady, documents are private, or network dependency is unacceptable.

## Hardware Constraints

Hardware sets the upper bound on what can be served. In practice, the main limiting factor is memory bandwidth and available VRAM or RAM, not just raw compute. A model may fit into memory only after quantization, but still perform poorly if the serving stack cannot move weights fast enough to sustain the desired token rate.

On laptops and edge devices, the question is usually whether a smaller quantized model can deliver acceptable quality. On servers, the question is more often concurrency: how many simultaneous requests can be handled before latency becomes unstable. CPU-only inference may be sufficient for offline batch tasks, but interactive applications typically benefit from GPUs or specialized accelerators.

The serving path is easier to reason about when visualized as a stack rather than a single black-box model process:

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,keepaspectratio]{assets/diagrams/local-llm-serving-stack.pdf}
\end{center}
```

## Quantization

Quantization reduces model memory footprint by representing weights with lower precision. This is one of the most important enablers of local deployment because it allows models that would otherwise be too large to fit on commodity hardware.

The tradeoff is that aggressive quantization can reduce output quality, especially for tasks that require nuanced reasoning, multilingual performance, or precise structured outputs. In practice, teams should compare a few quantization levels on their own tasks rather than assuming that a smaller file always delivers the same behavior.

Quantization is not just a storage detail. It affects throughput, latency, and sometimes prompt stability. The right choice depends on the model family, serving engine, and application tolerance for quality loss.

## Inference Engines

An inference engine is the runtime that loads the model, schedules token generation, and exposes an interface to the application. Different engines optimize for different goals: some prioritize broad hardware support, some focus on GPU efficiency, and some are designed for lightweight local workflows on desktops or edge systems.

When evaluating an engine, teams should look beyond simple tokens-per-second numbers. Important concerns include batching behavior, structured output support, model format compatibility, streaming behavior, observability, and how easy it is to upgrade models without changing application code.

## Model Selection Tradeoffs

Selecting a local model is a balancing exercise across quality, size, latency, context length, instruction-following ability, and operational cost. A smaller model with strong retrieval and careful prompting may outperform a larger model that receives weak context. For narrow domains, model reliability on the task distribution matters more than generalized benchmark prestige.

Teams should also decide whether the model is being used primarily for generation, extraction, classification, reranking, or query rewriting. Those jobs do not require the same model characteristics. Using one oversized model for every step is often less efficient than combining a capable generator with smaller specialized models in supporting roles.

## Practical Selection Process

A practical process starts with constraints, not preferences. Define the maximum latency, target hardware, concurrency needs, privacy requirements, and failure cost. Then select a small set of candidate models that fit within those boundaries.

Build a narrow evaluation set drawn from real queries and real documents. Compare model behavior on answer faithfulness, citation behavior, concise reasoning, formatting, and handling of missing information. The model that looks strongest in a generic chat session may not be the one that behaves best when paired with retrieval.

## Failure Patterns in Local Deployments

Local deployments often fail in predictable ways. Teams choose a model too large for their operational budget, which causes unstable latency. They trust a quantized variant without testing domain-specific regressions. They ignore prompt formatting differences across model families. Or they overlook the fact that long context windows can degrade effective attention quality even when technically supported.

Another common mistake is treating the model as the central problem and the retrieval pipeline as secondary. In RAG systems, local inference quality and retrieval quality are coupled. A model that is good at using evidence can compensate for some retrieval noise. A model that improvises confidently can magnify it.

## Chapter Summary

This chapter explained why teams run language models locally and how hardware, quantization, serving engines, and evaluation constraints shape model selection. The next step is to understand the retrieval substrate those models rely on: embeddings, chunking, and vector search.
