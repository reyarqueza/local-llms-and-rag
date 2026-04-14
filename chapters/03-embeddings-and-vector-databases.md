# Embeddings and Vector Databases

## What Embeddings Represent

Embeddings map text, and sometimes other modalities, into dense numeric vectors that capture semantic relationships. Two passages that express similar meaning should land relatively close together in vector space even when they do not share the same keywords.

This is what makes embeddings useful for retrieval. Instead of matching only literal terms, a system can find conceptually related content. That said, embeddings are not magic semantic truth machines. Their quality depends on the model, the domain, the chunking approach, and whether the query and document distributions match the tasks the embedding model was designed to support.

## Chunking Strategy

Chunking is one of the highest-leverage decisions in a RAG pipeline. Chunks that are too small may lose the context needed for retrieval. Chunks that are too large may mix multiple topics, reduce precision, and waste context window budget during generation.

Effective chunking depends on document structure. API references, support tickets, policy manuals, source code, and research papers all benefit from different segmentation strategies. In many cases, the best chunk boundary is a semantic unit such as a section, paragraph group, or function block rather than an arbitrary token count.

Overlap can help preserve continuity across boundaries, but too much overlap creates index bloat and redundant retrieval. A useful rule is to start with a simple structure-aware strategy, measure missed facts and noisy matches, and then refine based on observed failures.

## Indexing Documents

Indexing is more than turning text into vectors. A robust ingestion pipeline also normalizes source formats, extracts metadata, removes boilerplate, tracks document versions, and preserves enough provenance to explain where each chunk came from.

Metadata matters because many retrieval improvements come from filtering or ranking based on attributes such as source type, timestamp, permissions, product line, or document status. A vector index without supporting metadata is often too blunt for production retrieval.

The indexing path below shows why vectors alone are not sufficient. Retrieval quality depends on the combination of normalized text, chunk structure, metadata, and provenance:

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,keepaspectratio]{assets/diagrams/document-indexing-lifecycle.pdf}
\end{center}
```

Teams should also think about idempotency and refresh behavior. Documents change. New files arrive. Some chunks should be deleted, some updated, and some re-embedded only when their meaningful content changes.

## Similarity Search

Similarity search retrieves vectors that are close to the embedded query according to a chosen metric, often cosine similarity or dot product. Approximate nearest-neighbor search makes this efficient at scale, but introduces a speed-versus-recall tradeoff.

The key engineering question is not which algorithm sounds most advanced. It is whether retrieval returns the right candidates consistently enough for downstream reranking and generation to succeed. If the relevant chunk never enters the candidate set, no prompt engineering trick will recover it.

Similarity search is also only one layer of retrieval quality. Query rewriting, metadata filtering, hybrid lexical search, reranking, and diversity controls often matter as much as the underlying ANN index.

## Choosing a Vector Store

Choosing a vector store means choosing operational behavior as much as retrieval behavior. Teams should evaluate ingestion throughput, update semantics, metadata filtering, hybrid search support, scaling model, replication options, and integration friction with the rest of the stack.

For smaller systems, an embedded or lightweight store may be enough. For larger or multi-tenant systems, operational concerns such as sharding, backups, access control, and rolling reindexing become more important. A store that looks simple in a benchmark may create expensive operational work later if it lacks the filtering or lifecycle features your application needs.

## Embedding Model Selection

Embedding models should be chosen with the same discipline applied to generators. A general-purpose model may be fine for broad semantic similarity, but weak on code, legal text, biomedical terms, or multilingual corpora. Query-document alignment matters: the model should place user questions close to the chunks that contain the answer, not just semantically adjacent prose.

A strong evaluation set for embeddings includes queries that are easy, ambiguous, and adversarial. It should measure whether the right evidence appears in the top candidate set and how often retrieval is distracted by stylistically similar but factually irrelevant chunks.

## Common Retrieval Data Problems

Many retrieval issues originate in the documents themselves. OCR noise, duplicated content, stale files, missing titles, malformed tables, and permission mismatches can all degrade search quality. Teams often debug the vector database when the real problem is that the corpus was ingested without enough structural cleanup.

This is why indexing should be treated as a first-class pipeline with metrics, logs, and validation. If the input data is inconsistent, embedding quality and nearest-neighbor performance cannot save the system.

## Chapter Summary

This chapter covered embeddings, chunking, indexing, similarity search, and vector store selection. Together they form the retrieval substrate of a RAG system, and their quality determines whether the generator ever sees the evidence it needs.
