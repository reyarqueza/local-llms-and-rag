```{=latex}
\clearpage
```

# Evaluation and Debugging

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,trim=0 500 0 500,clip]{assets/images/chapter-06-evaluation.png}
\end{center}
```

This chapter shows how to measure the system and isolate where it fails. The goal is to turn iteration into a disciplined debugging loop.

## What to Measure

A RAG system should be measured at both the component level and the end-to-end level. Retrieval metrics tell you whether the right evidence is being found. Generation metrics tell you whether the answer is faithful, complete, and usable. Product metrics tell you whether the system is helping users accomplish their goals.

No single metric captures all of that. A useful evaluation program tracks retrieval recall at K, reranker performance, answer faithfulness, citation correctness, refusal behavior when evidence is missing, latency, and user satisfaction or task completion where available.

## Offline Evaluation

Offline evaluation is the fastest way to compare pipeline changes before shipping them. Build a dataset of representative queries, expected evidence, and expected answer properties. Then score different retrieval configurations, prompts, chunking strategies, rerankers, and models against the same set.

The best offline sets are small enough to maintain and rich enough to expose real failure modes. They should include ambiguous questions, outdated-document traps, multi-document questions, and cases where the correct behavior is to say that the corpus is insufficient.

## Human Review

Human review remains necessary because many important qualities are hard to capture with automated metrics alone. Reviewers can judge whether an answer is genuinely helpful, whether it overstates certainty, and whether the citation actually supports the claim being made.

Human review is especially useful when the domain includes policy interpretation, long-form synthesis, or subtle distinctions between partially correct and operationally dangerous outputs. The goal is not to replace automation, but to supplement it with higher-quality judgment on high-risk cases.

## Diagnosing Retrieval Failures

When an answer is wrong, start by asking whether the required evidence was retrieved at all. If not, the issue is upstream of generation. Check chunk boundaries, embedding quality, metadata filters, query rewriting, and corpus completeness.

A disciplined debugging approach records the top retrieved passages for each query and inspects whether the relevant chunk was absent, present but ranked too low, or present but overshadowed by noisy neighbors. Those cases suggest different fixes.

## Diagnosing Generation Failures

If the right evidence was retrieved but the answer is still poor, the problem may be in prompt construction, context ordering, model behavior, or synthesis policy. The model may have ignored the strongest passage, merged several passages incorrectly, or hallucinated details that were only weakly implied.

Generation debugging should compare the final answer to the prompt exactly as seen by the model. Teams often inspect retrieval outputs but forget to inspect the actual packed context after truncation and deduplication.

## Building Feedback Loops

Evaluation only becomes useful when it drives iteration. Production systems should log enough information to reproduce failures: query text, retrieval candidates, final packed context, model parameters, response text, and downstream user signals where privacy allows.

Those logs support three critical loops: adding new test cases from real failures, refining ranking and prompting strategies, and deciding when a model or pipeline change actually improves the system rather than just moving the failure around.

The evaluation loop should behave like an engineering control system, not a one-time benchmark run:

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,keepaspectratio]{assets/diagrams/evaluation-feedback-loop.pdf}
\end{center}
```

## Avoiding Metric Illusions

Teams can easily optimize for the wrong thing. A pipeline may improve lexical overlap while becoming less faithful. A larger context may increase recall while making synthesis worse. A benchmark improvement on a curated set may not survive contact with real documents and real users.

This is why evaluation should be adversarial. The purpose is not to prove the system works. It is to discover where it breaks before users do.

## Chapter Summary

This chapter described how to evaluate retrieval and generation together, when to use offline metrics versus human review, and how to debug failures systematically. Strong evaluation turns RAG development from trial and error into an engineering process.
