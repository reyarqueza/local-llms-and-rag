```{=latex}
\clearpage
```

# AI Terminology

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,trim=0 500 0 500,clip]{assets/images/chapter-09-ai-terminology.png}
\end{center}
```

This chapter gathers the AI vocabulary used across the book into one place. It works as a compact reference so readers can close with clearer definitions of the terms that appear throughout the manuscript.

## Why Close With Terminology

Modern AI systems are full of overlapping terms that sound intuitive but often mean something more specific in practice. A reader may know what a chatbot does, yet still be unclear on the difference between a model and an inference engine, an embedding and a vector, or retrieval and reranking.

This chapter gives short, practical definitions and examples. The goal is not to be academically complete. The goal is to leave the reader with a concise reference that reinforces the design and operational concepts covered earlier.

## Model Basics

**Model**  
A model is a learned function that maps input to output. In this book, the model is usually a language model that takes tokens as input and predicts likely next tokens.

Example: if you ask a model to summarize a policy document, the model produces the summary text.

**AI model**  
A general term for any trained model used for tasks such as generation, classification, ranking, or retrieval.

Example: a reranker is also an AI model, even though it does not behave like a chatbot.

**Language model**  
A model trained to predict sequences of text. Modern language models can answer questions, summarize, classify, extract fields, or rewrite content because those tasks can all be expressed as text prediction.

Example: a support assistant that answers questions from a product manual is usually powered by a language model.

**LLM**  
LLM stands for large language model. The term usually implies a model large enough to handle broad instruction-following, open-ended reasoning, and flexible text generation.

Example: a local 7B or 13B instruction-tuned model used in a private document assistant is an LLM.

**Parameters**  
Parameters are the learned numerical weights inside a model. They are what the training process adjusts.

Example: when people say a model has 7 billion parameters, they mean the model stores 7 billion learned values.

**Weights**  
Weights are the actual learned parameter values used during inference.

Example: quantization changes how the model weights are stored in memory.

**Training**  
Training is the process of learning model weights from data.

Example: a base model is trained on a large corpus before you ever download it for local use.

**Inference**  
Inference is the act of running a trained model to get an output.

Example: every time your application sends a prompt to a local model and receives tokens back, it is performing inference.

**Fine-tuning**  
Fine-tuning means taking an already trained model and training it further on a narrower dataset or task.

Example: a company might fine-tune a base model to follow its own internal response style.

**Base model**  
A base model is a model before task-specific instruction tuning or alignment steps.

Example: a base model may be strong at language patterns but poor at following direct chat-style instructions.

**Instruction-tuned model**  
A model that has been tuned to follow user instructions more reliably.

Example: when you ask a model to produce a JSON object or answer in bullet points, instruction tuning usually makes that behavior more reliable.

## Prompting and Generation

**Prompt**  
A prompt is the input sent to a language model. It may include instructions, user questions, retrieved evidence, formatting rules, and examples.

Example: a prompt might say, "Answer using only the retrieved passages and cite the source number."

**System prompt**  
A high-priority instruction block that defines the model's role and constraints.

Example: "You are an internal documentation assistant. Do not invent unsupported facts."

**Completion**  
A completion is the model's generated output.

Example: the answer text returned after a prompt is a completion.

**Token**  
A token is a chunk of text the model processes internally. Tokens are not exactly words. A short word may be one token, while a long word may be split into several.

Example: the sentence "local models are useful" is represented internally as a sequence of tokens, not raw characters.

**Tokenization**  
Tokenization is the process of converting text into tokens.

Example: two model families may treat the same sentence as different token counts because they use different tokenizers.

**Context window**  
The maximum amount of tokenized input a model can consider at once.

Example: if a model has a 32k context window, your prompt plus retrieved passages plus output budget all need to fit within that limit.

**Prompt budget**  
The portion of the context window available for instructions and evidence after reserving space for the output.

Example: if you want a long answer, you may have less room left for retrieved passages.

**Hallucination**  
A hallucination is a generated claim that is unsupported, fabricated, or misleading.

Example: if a model invents a product policy that is not in the retrieved documentation, that is a hallucination.

**Grounding**  
Grounding means tying the model's answer to external evidence rather than relying only on what is stored in model weights.

Example: a grounded answer cites retrieved passages from the manual instead of improvising from memory.

**Parametric memory**  
Information stored implicitly in the model's learned weights rather than looked up at runtime.

Example: a model may know general facts about Python syntax from training, but it will not reliably know your company's latest support policy from parametric memory alone.

## Representations and Retrieval

**Embedding**  
An embedding is a dense numeric representation of text, or another modality, used to compare semantic similarity.

Example: two chunks about password reset procedures may produce nearby embeddings even if they use different wording.

**Vector**  
A vector is an ordered list of numbers. In this context, it usually refers to an embedding.

Example: a paragraph might become a 768-dimensional vector before being stored for search.

**Dense representation**  
A representation that uses many learned numeric dimensions instead of sparse keyword counts.

Example: embeddings are dense representations because most dimensions carry some value.

**Semantic similarity**  
Similarity based on meaning rather than exact keyword overlap.

Example: "reset my login" and "recover account access" may be semantically similar even if they share few words.

**Chunk**  
A chunk is a smaller unit of text created from a larger document so it can be embedded, indexed, and retrieved.

Example: one section of a handbook might become one chunk in the retrieval system.

**Chunking**  
The process of splitting documents into chunks.

Example: a long policy document may be chunked by headings so retrieval returns focused sections instead of the full file.

**Corpus**  
The collection of documents available to the system.

Example: an internal knowledge assistant may use a corpus made of product docs, support macros, and policy manuals.

**Index**  
A data structure that makes retrieval efficient.

Example: the vector index lets the system search millions of embeddings without comparing every vector directly.

**Vector database / vector store**  
A storage system optimized for writing, filtering, and searching embeddings.

Example: the vector store may hold both chunk embeddings and metadata such as source type or timestamp.

**Similarity search**  
Searching for stored vectors that are close to a query vector.

Example: after embedding a user question, the system retrieves nearby chunk vectors from the index.

**Nearest neighbor search**  
The core retrieval problem of finding the stored vectors closest to the query vector.

Example: the search engine asks which chunks are nearest to the question embedding.

**Approximate nearest neighbor (ANN)**  
A fast method for nearest neighbor search that trades exactness for speed at scale.

Example: ANN may return a very good candidate set quickly even if it does not prove the mathematically exact top result.

**Cosine similarity**  
A measure of how aligned two vectors are, often used to compare embeddings.

Example: if two embeddings point in similar directions, they have high cosine similarity.

**Dot product**  
Another way to compare vectors, often used depending on how the embedding model was trained.

Example: some embedding models are designed so dot product is the right scoring function for retrieval.

**Metadata**  
Structured attributes attached to documents or chunks.

Example: source, timestamp, access policy, product line, and document status are all metadata fields.

**Filter**  
A rule that narrows retrieval candidates using metadata.

Example: a support assistant might search only documents tagged for the current product version.

**Provenance**  
Information about where a retrieved chunk came from.

Example: provenance may include the document ID, section title, page number, or URL used for citation.

## RAG Pipeline Terms

**RAG**  
RAG stands for retrieval-augmented generation. The system retrieves relevant context first and then gives that context to a model during generation.

Example: instead of asking the model to answer from memory, the application first finds the relevant handbook sections and passes them into the prompt.

**Retriever**  
The component that finds candidate evidence for a query.

Example: the retriever searches the vector store for chunks likely to answer the user question.

**Candidate set**  
The initial group of retrieved chunks considered for downstream ranking or prompt assembly.

Example: the retriever may return the top 20 chunks as the candidate set before reranking.

**Reranker**  
A second-stage model or heuristic that reorders retrieved candidates using a more precise relevance signal.

Example: a reranker may move the exact password-reset policy above a more generic account-help article.

**Recall**  
A measure of whether the relevant evidence was retrieved at all.

Example: high recall means the needed chunk usually appears somewhere in the candidate set.

**Precision**  
A measure of how many retrieved results are actually relevant.

Example: if the top results are mostly on-topic and not noisy, precision is higher.

**Hybrid retrieval**  
A retrieval strategy that combines vector search with lexical or keyword search.

Example: exact product codes may be better handled by keyword search, while conceptual questions may benefit from embeddings.

**Query rewriting**  
Transforming the user's question into a form that may retrieve better evidence.

Example: "Why is login broken?" might be rewritten into "account authentication failure troubleshooting."

**Query expansion**  
Adding related terms or variants to improve recall.

Example: a query about "GPU memory" might be expanded with "VRAM."

**Prompt assembly**  
The step where instructions, user input, and retrieved evidence are packaged into the final model input.

Example: the system might place citations after each passage and then append the user question below them.

**Response synthesis**  
Turning multiple pieces of retrieved evidence into one answer.

Example: a model may combine two policy sections and one FAQ entry into a single supported explanation.

**Citation**  
A reference that shows which source supports a claim.

Example: a support answer might say, "Reset tokens expire after 15 minutes [Doc 3]."

**Clarification question**  
A follow-up question asked when the user's request is too vague or retrieval results are weak.

Example: "Are you asking about the mobile app or the web dashboard?" is a clarification question.

## Serving and Systems Terms

**Local model**  
A model running on hardware you control rather than only through a hosted API.

Example: running a quantized model on a company workstation or private server is local deployment.

**Hosted model**  
A model accessed over an external network API.

Example: calling a commercial chat API is hosted inference rather than local inference.

**Inference engine**  
A runtime that loads model weights and serves generation requests.

Example: an inference engine handles token generation, batching, and model memory management.

**Quantization**  
A technique for storing model weights in lower precision so the model needs less memory.

Example: moving from 16-bit weights to a 4-bit quantized format may let a model fit on smaller hardware.

**VRAM**  
Video RAM, usually the memory on a GPU.

Example: if the model weights do not fit into GPU VRAM, generation may slow down or fail.

**RAM**  
System memory used by the CPU and the operating system.

Example: a CPU-only local deployment may rely heavily on system RAM.

**Batching**  
Combining multiple requests or token operations into one execution step for efficiency.

Example: an inference engine may batch several user requests to improve throughput.

**Latency**  
How long a request takes from start to finish.

Example: if a user waits eight seconds for an answer, the end-to-end latency is eight seconds.

**Throughput**  
How much work the system can complete over time.

Example: a system serving 40 requests per minute has higher throughput than one serving 10.

**Concurrency**  
How many requests the system can handle at the same time.

Example: a model that feels fast for one user may slow down badly under concurrent load.

**Streaming**  
Returning generated tokens incrementally as they are produced.

Example: a chat UI that shows the answer word by word is using streaming output.

## Evaluation and Reliability Terms

**Evaluation**  
A structured process for measuring system quality.

Example: a team may compare two retrievers on the same query set to see which one retrieves better evidence.

**Benchmark**  
A fixed evaluation setup used to compare systems.

Example: a benchmark might score answer quality across a shared set of representative questions.

**Offline evaluation**  
Evaluation performed on saved datasets rather than live user traffic.

Example: before shipping a new reranker, you may test it on a curated dataset of historical questions.

**Human review**  
Manual judgment by people inspecting outputs and evidence.

Example: reviewers may check whether a cited passage really supports the model's answer.

**Faithfulness**  
Whether an answer accurately reflects the retrieved evidence.

Example: an answer can be fluent but unfaithful if it subtly changes what the source actually says.

**Recall at K**  
A retrieval metric that asks whether the relevant result appears within the top K retrieved items.

Example: recall at 5 is good if the needed chunk usually appears in the top five results.

**Failure mode**  
A recurring way a system can go wrong.

Example: one failure mode is retrieving stale documentation and presenting it confidently.

**Observability**  
The ability to inspect system behavior through logs, traces, and metrics.

Example: good observability lets you see the query, retrieved passages, final prompt, and output for a failed answer.

**Feedback loop**  
A process where failures are captured, analyzed, and used to improve the system.

Example: a bad production answer may become a new test case in the offline evaluation set.

**Trust calibration**  
How well the system's confidence and behavior match what it actually knows.

Example: a well-calibrated assistant admits uncertainty when the corpus does not support a claim.

## Emerging Directions

**Agentic system / agentic retrieval**  
A system that can take multiple steps, decide what to do next, and use tools or iterative retrieval along the way.

Example: instead of retrieving once, an agentic system may search, inspect results, ask another question, and then synthesize an answer.

**Multimodal**  
A system that handles more than one type of input or evidence, such as text, images, tables, or audio.

Example: multimodal RAG may retrieve both a troubleshooting diagram and the text manual that explains it.

**On-device inference**  
Running a model directly on the end user's device.

Example: a phone app that summarizes private notes without sending them to a server is using on-device inference.

## How To Use This Chapter

You do not need to memorize every definition before continuing. The point of this chapter is to give you a reference point for the rest of the book. If a later section uses terms such as reranker, context window, recall at K, or parametric memory, you can return here and re-anchor the concept quickly.

As you read the later chapters, try to map each system decision to one of the terms introduced here. That habit makes it easier to tell whether a problem is about model behavior, retrieval quality, prompt design, operational limits, or evaluation discipline.

## Chapter Summary

This chapter defined the general AI and RAG terminology used throughout the manuscript. With this vocabulary in place, the remaining chapters can focus on system design and tradeoffs rather than basic definitions.
