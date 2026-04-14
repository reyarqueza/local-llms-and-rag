# Local LLMs and RAG

A technical book draft about building applications with local language models, embeddings, vector databases, and retrieval-augmented generation.

## Structure

```text
local-llms-and-rag/
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
  diagrams/
    mermaid/
  examples/
    python/
  scripts/
    build-book.sh
```

## Build

The repository includes a build script that renders Mermaid source files into vector diagram assets before producing the PDF.

```bash
./scripts/build-book.sh
```

## Mermaid Diagrams

Keep Mermaid source files in `diagrams/mermaid/`. The build script renders each `.mmd` file into:

- `assets/diagrams/<name>.svg`
- `assets/diagrams/<name>.pdf`

For manuscript chapters that are intended for PDF output, reference the generated PDF asset so the diagram stays vector in the final PDF:

```md
![RAG pipeline overview](assets/diagrams/rag-pipeline-overview.pdf)
```

The generated SVG can still be used for web or repository previews.

## Requirements

- `pandoc`
- `xelatex`
- `mmdc` from Mermaid CLI

Example installation for Mermaid CLI:

```bash
npm install -g @mermaid-js/mermaid-cli
```
