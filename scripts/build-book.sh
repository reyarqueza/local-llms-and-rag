#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MERMAID_SRC_DIR="$ROOT_DIR/diagrams/mermaid"
DIAGRAM_OUT_DIR="$ROOT_DIR/assets/diagrams"
ILLUSTRATION_SRC_DIR="$ROOT_DIR/assets/images/source"
ILLUSTRATION_OUT_DIR="$ROOT_DIR/assets/images"
OUTPUT_PDF="$ROOT_DIR/book.pdf"
BOOK_ENTRYPOINT="$ROOT_DIR/book.md"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_cmd pandoc
require_cmd xelatex
require_cmd mmdc

render_illustration_png() {
  local src="$1"
  local out="$2"
  local tmp_dir
  local thumb_name

  tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/local-llm-rag-illustration.XXXXXX")"
  thumb_name="$(basename "$src").png"

  qlmanage -t -s 2200 -o "$tmp_dir" "$src" >/dev/null
  mv "$tmp_dir/$thumb_name" "$out"
  rm -rf "$tmp_dir"
}

expand_book() {
  local source_file="$1"
  local output_file="$2"
  local source_dir
  local in_include_block=0

  source_dir="$(cd "$(dirname "$source_file")" && pwd)"
  : > "$output_file"

  while IFS= read -r line || [ -n "$line" ]; do
    if [ "$in_include_block" -eq 0 ] && [ "$line" = '```{=include}' ]; then
      in_include_block=1
      continue
    fi

    if [ "$in_include_block" -eq 1 ]; then
      if [ "$line" = '```' ]; then
        in_include_block=0
        continue
      fi

      if [ -n "$line" ]; then
        local include_path="$source_dir/$line"

        if [ ! -f "$include_path" ]; then
          echo "Missing included file: $line" >&2
          exit 1
        fi

        cat "$include_path" >> "$output_file"
        printf '\n\n' >> "$output_file"
      fi

      continue
    fi

    printf '%s\n' "$line" >> "$output_file"
  done < "$source_file"
}

mkdir -p "$DIAGRAM_OUT_DIR"
mkdir -p "$ILLUSTRATION_OUT_DIR"

shopt -s nullglob
mermaid_files=("$MERMAID_SRC_DIR"/*.mmd)
shopt -u nullglob

if [ "${#mermaid_files[@]}" -gt 0 ]; then
  echo "Rendering Mermaid diagrams..."
  for src in "${mermaid_files[@]}"; do
    base_name="$(basename "${src%.mmd}")"
    svg_out="$DIAGRAM_OUT_DIR/$base_name.svg"
    pdf_out="$DIAGRAM_OUT_DIR/$base_name.pdf"

    mmdc -i "$src" -o "$svg_out"
    mmdc -i "$src" -o "$pdf_out" --pdfFit
  done
fi

if command -v qlmanage >/dev/null 2>&1; then
  shopt -s nullglob
  illustration_files=("$ILLUSTRATION_SRC_DIR"/*.svg)
  shopt -u nullglob

  if [ "${#illustration_files[@]}" -gt 0 ]; then
    echo "Rendering chapter illustrations..."
    for src in "${illustration_files[@]}"; do
      base_name="$(basename "${src%.svg}")"
      png_out="$ILLUSTRATION_OUT_DIR/$base_name.png"

      render_illustration_png "$src" "$png_out"
    done
  fi
fi

TMP_BOOK="$(mktemp "${TMPDIR:-/tmp}/local-llm-rag-book.XXXXXX.md")"
trap 'rm -f "$TMP_BOOK"' EXIT

expand_book "$BOOK_ENTRYPOINT" "$TMP_BOOK"

echo "Building PDF..."
pandoc \
  --from markdown \
  --metadata-file="$ROOT_DIR/metadata.yaml" \
  --pdf-engine=xelatex \
  -o "$OUTPUT_PDF" \
  "$TMP_BOOK"

echo "Wrote $OUTPUT_PDF"
