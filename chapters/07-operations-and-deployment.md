# Deployment and Operations

## Latency and Throughput

Operational quality matters because even a highly accurate system fails if users cannot rely on it. Latency is shaped by query preprocessing, retrieval, reranking, prompt assembly, and generation. Throughput is constrained by hardware, model size, batching behavior, and concurrency limits.

The right target depends on the application. An internal research assistant can tolerate slower answers than a support workflow embedded in a live customer interaction. Teams should set explicit service objectives instead of treating performance as an afterthought.

## Caching

Caching can reduce cost and improve responsiveness, but only when applied carefully. Useful cache layers include embedding caches for repeated documents, retrieval caches for common queries, and response caches for deterministic or semi-deterministic prompts.

The danger is staleness. If the corpus changes frequently, a cache key must incorporate document or index versioning. Otherwise the system may respond quickly with obsolete answers, which is worse than being slow.

## Observability

Observability for RAG should cover both infrastructure and application behavior. Infrastructure metrics include CPU and GPU utilization, memory pressure, queue depth, and request latency. Application metrics include retrieval hit patterns, citation usage, empty-result rate, refusal rate, and the distribution of document sources appearing in answers.

Logs should make it possible to inspect a bad response end to end. That means preserving query text, retrieval candidates, reranker scores, packed context, output text, and enough identifiers to trace the documents involved. Without that visibility, teams are forced to guess.

## Privacy and Security

Local deployment can improve privacy, but only if the surrounding system is designed accordingly. Sensitive documents should have clear access controls, encrypted storage where appropriate, and audit trails for ingestion and query access. Multi-tenant systems need strict separation at both the document and retrieval layers.

Prompt logs, embeddings, and cached outputs can also contain sensitive information. Teams sometimes secure the model host but leave operational artifacts underprotected. Security must apply to the full data path, not just the inference process.

## Updating the Index

Real-world corpora change continuously. New documents are added, existing ones are revised, and some should be deleted. Index maintenance should therefore be an operational capability, not a manual script run when something looks wrong.

An effective update strategy includes document versioning, incremental re-embedding, backfills for schema changes, and monitoring for ingestion lag. If update behavior is unreliable, users quickly lose trust because the system appears knowledgeable but outdated.

## Capacity Planning

Capacity planning for local AI systems requires modeling both average load and bursts. Retrieval services, rerankers, and generators may scale differently, and the slowest stage often shifts over time as usage patterns change.

Teams should test under concurrency, not just single-request benchmarks. A model that looks acceptable in isolation may collapse under parallel load once queueing and memory contention appear.

## Operational Maturity

A mature deployment has explicit rollback paths, canary strategies for pipeline changes, and a repeatable way to compare model or retrieval variants before promotion. It also defines how incidents are handled when the system serves stale, unsupported, or policy-violating answers.

The operational bar should rise with the business importance of the workflow. A casual internal tool can tolerate more experimentation than a system that supports customers, compliance work, or high-value decision making.

## Chapter Summary

This chapter covered the operational realities of shipping local RAG systems: latency, throughput, caching, observability, privacy, and index maintenance. Production success depends on making the system inspectable, updatable, and predictable under real usage.
