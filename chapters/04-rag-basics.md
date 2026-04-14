# RAG Fundamentals

## The Basic RAG Loop

At a high level, a RAG system performs four steps: accept a user query, retrieve relevant context, construct a prompt that combines the query and the evidence, and generate a response. The point of the loop is to ground generation in retrieved information rather than relying only on parametric memory.

This architecture is simple to describe but easy to oversimplify. Each stage introduces choices that affect the others. Query formulation changes retrieval quality. Retrieval ordering changes what context fits into the prompt. Prompt structure changes whether the model uses the evidence well or ignores it.

The loop below makes explicit the decision point many demos omit: generation should not proceed as if nothing is wrong when retrieval fails to produce usable evidence.

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,keepaspectratio]{assets/diagrams/rag-request-loop.pdf}
\end{center}
```

## Retrieval Before Generation

The most important discipline in RAG is that retrieval should constrain generation. If the system cannot retrieve relevant evidence, it should narrow the task, ask a clarification question, or admit uncertainty. A model that answers confidently without supporting evidence is often worse than one that answers less often.

Retrieval also changes the notion of correctness. In a grounded system, a good answer is not just fluent. It is faithful to the retrieved context, appropriately scoped, and explicit about when the corpus does not support a claim.

## Prompt Construction

Prompt construction is the bridge between retrieval and generation. The prompt should tell the model what role it is playing, what evidence is available, what the user asked, and how to behave when evidence is incomplete or conflicting.

A practical prompt usually includes clear separators between system instructions, user input, and retrieved passages. It may also specify output format, citation style, and rules against fabricating unsupported claims. Good prompts are explicit about precedence: instructions should override retrieved text, and retrieved text should override unsupported model guesses.

## Common Failure Modes

RAG systems fail in recurring ways. The retriever may miss the right chunk entirely. It may return the right chunk along with many irrelevant ones, burying the answer in noise. The generator may ignore evidence, overfit to one passage, or combine partially related chunks into a misleading synthesis.

Another common failure is context poisoning: a retrieved passage looks relevant but contains stale or contradictory information. Without clear provenance and ranking discipline, the model may absorb the wrong evidence and produce a polished but unreliable answer.

## Why Citations Matter

Citations create a useful contract between system and user. They let the user inspect where a claim came from and help engineers diagnose whether a failure originated in retrieval or synthesis. Even when citations are not shown in the final product, preserving passage provenance internally is critical for debugging.

The purpose of citations is not decoration. It is accountability. A system that cannot tell you where its answer came from is hard to trust and hard to improve.

## From Demo To System

The jump from a demo to a production system is usually the point where teams discover that RAG is not just prompting. Reliable RAG requires corpus hygiene, chunking strategy, ranking controls, prompt discipline, fallbacks for empty retrieval, and evaluation against real workloads.

This is why simple notebook examples can be misleading. They show the happy path. Engineering work begins when the retriever returns the wrong evidence, the corpus changes weekly, and users ask questions that span multiple documents or require reasoning over partial information.

## Chapter Summary

This chapter introduced the basic RAG loop, explained why retrieval must constrain generation, and described the most common failure modes. The next chapter expands that loop into a complete pipeline with ingestion, ranking, context management, and response synthesis.
