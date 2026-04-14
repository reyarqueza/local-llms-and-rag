• Use a chapter-per-file structure and keep a separate manuscript entrypoint for PDF builds.

  Structure

  local-llm-rag-book/
    README.md
    outline.md
    metadata.yaml
    book.md
    chapters/
      01-introduction.md
      02-local-llms.md
      03-embeddings-and-vector-databases.md
      04-rag-basics.md
      05-rag-pipeline-design.md
      06-evaluation.md
      07-operations-and-deployment.md
      08-future-directions.md
    assets/
      images/
      diagrams/
    examples/
      python/

  README.md

  # Local LLMs and RAG

  A technical book draft about building applications with local language models, embeddings, vector databases, and
  retrieval-augmented generation.

  ## Build

  Example with Pandoc:

  ```bash
  pandoc --from markdown --metadata-file=metadata.yaml --pdf-engine=xelatex -o book.pdf book.md


  **`metadata.yaml`**

  ```yaml
  title: "Building with Local LLMs and RAG"
  subtitle: "Practical Patterns for Retrieval-Augmented AI Systems"
  author: "Your Name"
  date: "2026-04-09"
  lang: "en-US"
  toc: true
  toc-depth: 2
  numbersections: true
  fontsize: 11pt
  geometry: margin=1in
  colorlinks: true
  linkcolor: blue
  urlcolor: blue

  book.md

  % Building with Local LLMs and RAG

  \newpage

  # Preface

  This book is a practical guide to designing and shipping applications built on local language models, embeddings,
  vector search, and retrieval-augmented generation.

  \newpage

  ```{=include}
  chapters/01-introduction.md

  chapters/02-local-llms.md

  chapters/03-embeddings-and-vector-databases.md

  chapters/04-rag-basics.md

  chapters/05-rag-pipeline-design.md

  chapters/06-evaluation.md

  chapters/07-operations-and-deployment.md

  chapters/08-future-directions.md


  If your Markdown toolchain does not support include syntax, concatenate files in a build script instead.

  **`outline.md`**

  ```md
  # Outline

  1. Introduction
  2. Running LLMs Locally
  3. Embeddings and Vector Databases
  4. RAG Fundamentals
  5. Designing a RAG Pipeline
  6. Evaluation and Debugging
  7. Deployment and Operations
  8. Where the Field Is Going

  Chapter template

  Example: chapters/01-introduction.md

  # Introduction

  ## Who This Book Is For

  This book is for engineers building AI applications with local models, private data, and retrieval pipelines.

  ## What Problem This Book Solves

  Many teams understand the high-level ideas behind local LLMs and RAG, but struggle with system design, tradeoffs, and
  production reliability.

  ## What You Will Build

  By the end of this book, the reader should understand how to:

  - run and select local language models
  - create embeddings and index documents
  - build a retrieval pipeline
  - improve answer quality with evaluation
  - operate the system in production

  ## Key Terms

  **Local LLM**
  A language model run on local hardware or private infrastructure.

  **Embedding**
  A dense vector representation used for semantic similarity.

  **Vector database**
  A storage and query system optimized for nearest-neighbor retrieval.

  **RAG**
  Retrieval-augmented generation: retrieving relevant context and injecting it into generation.

  ## Chapter Summary

  This chapter introduced the scope of the book and defined the core terms used throughout the rest of the manuscript.

  More chapter starters

  chapters/02-local-llms.md

  # Running LLMs Locally

  ## Why Run Models Locally

  ## Hardware Constraints

  ## Quantization

  ## Inference Engines

  ## Model Selection Tradeoffs

  ## Chapter Summary

  chapters/03-embeddings-and-vector-databases.md

  # Embeddings and Vector Databases

  ## What Embeddings Represent

  ## Chunking Strategy

  ## Indexing Documents

  ## Similarity Search

  ## Choosing a Vector Store

  ## Chapter Summary

  chapters/04-rag-basics.md

  # RAG Fundamentals

  ## The Basic RAG Loop

  ## Retrieval Before Generation

  ## Prompt Construction

  ## Common Failure Modes

  ## Chapter Summary

  chapters/05-rag-pipeline-design.md

  # Designing a RAG Pipeline

  ## Ingestion Pipeline

  ## Query Processing

  ## Retrieval and Reranking

  ## Context Window Management

  ## Response Synthesis

  ## Chapter Summary

  chapters/06-evaluation.md

  # Evaluation and Debugging

  ## What to Measure

  ## Offline Evaluation

  ## Human Review

  ## Diagnosing Retrieval Failures

  ## Diagnosing Generation Failures

  ## Chapter Summary

  chapters/07-operations-and-deployment.md

  # Deployment and Operations

  ## Latency and Throughput

  ## Caching

  ## Observability

  ## Privacy and Security

  ## Updating the Index

  ## Chapter Summary

  chapters/08-future-directions.md

  # Future Directions

  ## Agentic Retrieval

  ## Multimodal RAG

  ## On-Device Inference

  ## Open Problems

  ## Final Thoughts

  Writing conventions

  - Put one # H1 per chapter file.
  - Use ## for sections and ### sparingly.
  - Keep images under assets/images/ and reference them relatively.
  - Keep code samples in examples/ if they get long.
  - Add a short Chapter Summary at the end of each chapter.
  - Use README.md for repo/build instructions, not the whole manuscript.

  Diagram and build conventions

  - Keep editable diagram sources in `diagrams/mermaid/` as `.mmd` files and render build artefacts into `assets/diagrams/`.
  - Keep chapter opener illustration source files in `assets/images/source/` as SVGs and render build artefacts into `assets/images/`.
  - For PDF output, reference the generated `.pdf` diagram assets from chapter files.
  - For chapter opener illustrations in PDF output, reference the generated `.png` assets from chapter files.
  - The build must render Mermaid PDFs with `mmdc --pdfFit` so exported diagrams are cropped to the chart bounds instead of keeping excess white page space.
  - The build may use macOS Quick Look via `qlmanage -t` to rasterize SVG illustrations into high-resolution PNGs for the PDF build.
  - Keep `book.md` as the manuscript entrypoint, but do not assume Pandoc expands the fenced ````{=include}```` block by itself. The build script should concatenate the referenced chapter files into a temporary manuscript before invoking Pandoc.
  - For inline PDF layout, prefer raw LaTeX image blocks over captioned Markdown figures when you need diagrams to stay embedded with the surrounding text instead of floating.
  - Use this inline pattern in chapter files for full-width embedded diagrams:

  ```md
  ```{=latex}
  \begin{center}
  \includegraphics[width=\textwidth,keepaspectratio]{assets/diagrams/example.pdf}
  \end{center}
  ```
  ```

  - Keep `metadata.yaml` loading `graphicx` so inline LaTeX `\includegraphics` blocks compile correctly.
  - Avoid depending on optional LaTeX packages unless they are already known to exist in the environment. In this repo, native LaTeX `\@startsection` redefinition worked for large chapter heading styling when `titlesec` was unavailable.
  - Mermaid diagrams should be designed for a wide, low aspect ratio so `width=\textwidth` uses the page efficiently. Prefer `flowchart LR`, larger font sizes, and generous horizontal spacing in Mermaid `init` blocks.
  - If a diagram looks too small at full width, fix the Mermaid source layout first. Do not reintroduce aggressive LaTeX height caps unless a specific diagram truly needs one.

  Chapter opener conventions

  - Each chapter should begin on a new page and follow a consistent opener layout: oversized chapter title, editorial illustration, then a very short 1-2 sentence chapter description.
  - Keep the opener description minimal so the opener remains on one page and does not push body text awkwardly to the next page.
  - Use a full-width centered image block for opener art. If the rendered image has extra top or bottom whitespace, crop it in the LaTeX embed with `trim=... ,clip` rather than shrinking the image width.
  - The opener illustrations should use a consistent black-and-white wireframe editorial style. Keep strokes bold, fills white, and compositions simple enough to read at chapter-opening scale.
  - The character in each chapter opener should be doing something specific to that chapter topic. Keep the visual metaphor obvious and simple.
  - Preserve editability: store the illustration source as SVG even if the PDF build uses generated PNG artefacts.

  Pandoc-friendly image example

  ![RAG pipeline overview](assets/images/rag-pipeline.png)

  Simple build command

  pandoc book.md --metadata-file=metadata.yaml --pdf-engine=xelatex -o book.pdf
