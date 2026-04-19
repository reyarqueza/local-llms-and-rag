#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MERMAID_SRC_DIR="$ROOT_DIR/diagrams/mermaid"
DIAGRAM_OUT_DIR="$ROOT_DIR/assets/diagrams"
ILLUSTRATION_SRC_DIR="$ROOT_DIR/assets/images/source"
ILLUSTRATION_OUT_DIR="$ROOT_DIR/assets/images"
SVG_ASSET_DIR="$ROOT_DIR/assets/svg"
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

render_svg_pdf() {
  local src="$1"
  local out="$2"

  inkscape "$src" --export-type=pdf --export-filename="$out" >/dev/null 2>&1
}

normalize_manuscript_line() {
  local line="$1"

  if [[ "$line" == *"assets/svg/"*".svg"* ]]; then
    line="${line//.svg/.pdf}"
  fi

  printf '%s\n' "$line"
}

expand_book() {
  local source_file="$1"
  local output_file="$2"
  local source_dir
  local include_line
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

        while IFS= read -r include_line || [ -n "$include_line" ]; do
          normalize_manuscript_line "$include_line" >> "$output_file"
        done < "$include_path"
        printf '\n\n' >> "$output_file"
      fi

      continue
    fi

    normalize_manuscript_line "$line" >> "$output_file"
  done < "$source_file"
}

mkdir -p "$DIAGRAM_OUT_DIR"
mkdir -p "$ILLUSTRATION_OUT_DIR"
mkdir -p "$SVG_ASSET_DIR"

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

if command -v inkscape >/dev/null 2>&1; then
  shopt -s nullglob
  svg_asset_files=("$SVG_ASSET_DIR"/*.svg)
  shopt -u nullglob

  if [ "${#svg_asset_files[@]}" -gt 0 ]; then
    echo "Rendering SVG vector assets..."
    for src in "${svg_asset_files[@]}"; do
      base_name="$(basename "${src%.svg}")"
      pdf_out="$SVG_ASSET_DIR/$base_name.pdf"

      render_svg_pdf "$src" "$pdf_out"
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
