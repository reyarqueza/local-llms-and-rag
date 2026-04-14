```{=latex}
\clearpage
```

# Designing a RAG Pipeline

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,trim=0 500 0 500,clip]{assets/images/chapter-05-rag-pipeline-design.png}
\end{center}
```

This chapter turns the basic loop into a real system. It breaks the pipeline into ingestion, ranking, context management, and response synthesis.

## Ingestion Pipeline

The ingestion pipeline determines what knowledge is available at query time and in what form. It should parse source documents, normalize structure, extract metadata, chunk content, compute embeddings, and write both vectors and provenance data into storage.

A production ingestion flow also needs operational properties: repeatability, version tracking, and safe reprocessing. If a document is updated, the system should know which chunks must be replaced. If an extraction step fails, the system should record the failure rather than silently producing incomplete coverage.

## Query Processing

Raw user queries are often underspecified. Query processing may include normalization, spelling repair, entity expansion, decomposition, or conversion into multiple retrieval queries. The right level of preprocessing depends on the domain. Over-processing can distort the user's intent, but a small amount of structure can improve recall significantly.

Some systems also classify the request before retrieval. For example, a question may be routed differently if it is asking for a factual answer, a document summary, a comparison across sources, or a policy-sensitive response that requires stricter evidence handling.

## Retrieval and Reranking

Initial retrieval should aim for high recall: get a manageable candidate set that likely contains the needed evidence. Reranking then improves precision by reordering those candidates with a model or heuristic that better captures task-specific relevance.

This two-stage design is common because it separates scale from accuracy. Vector search can efficiently scan a large corpus, while reranking can spend more computation on a small set of promising passages. In many systems, reranking provides a larger quality gain than increasing the size of the generator.

## Context Window Management

Even models with large context windows have practical limits. Every retrieved passage consumes prompt budget and attention. Packing too much context into the prompt can reduce answer quality by diluting the most relevant evidence.

Context management involves selecting, ordering, trimming, and sometimes compressing retrieved passages. The best context set is not always the top N results from the retriever. It may require removing near-duplicates, preferring complementary passages, or reserving space for system instructions and structured output constraints.

## Response Synthesis

Response synthesis is where the model turns evidence into an answer. The synthesis strategy should match the task. A short factual answer may need tight grounding and direct citations. A summary may require merging evidence across multiple chunks while preserving uncertainty. A workflow assistant may need to extract steps rather than produce prose.

This stage should also define fallback behavior. If evidence is missing or contradictory, the system should say so clearly. A good synthesis layer does not merely generate text. It enforces the contract between the application and the user about what counts as a supported answer.

## Architectural Variants

There is no single correct RAG architecture. Some systems use hybrid retrieval that combines lexical and vector search. Some rewrite the query before retrieval. Some perform multi-hop retrieval across several rounds. Some attach tools for structured data lookup alongside document search.

What matters is that each component has a reason to exist and a measurable effect. Architectural complexity should be earned by observable gains, not added because it sounds advanced.

## Example Pipeline Sketch

A practical pipeline can be visualized as:

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,keepaspectratio]{assets/diagrams/rag-pipeline-overview.pdf}
\end{center}
```

1. Ingest documents and extract clean text plus metadata.
2. Chunk the content using structure-aware rules.
3. Generate embeddings and store vectors with provenance.
4. Process the user query and classify the task.
5. Retrieve a candidate set from the index.
6. Rerank and prune passages for prompt assembly.
7. Generate a grounded response with citations or uncertainty.
8. Log the interaction for evaluation and future debugging.

This flow is simple enough to implement but structured enough to support iterative improvement. It also exposes clear measurement points, which makes system tuning far easier than treating the pipeline as a single opaque prompt.

## Chapter Summary

This chapter broke the RAG system into ingestion, query processing, retrieval, reranking, context management, and synthesis. Designing the pipeline at this level makes it possible to isolate failure modes and improve the system component by component.
