#!/bin/sh
# Build cv.pdf and stage it for GitHub Pages in docs/.
set -eu

cd "$(dirname "$0")"

# -g forces a rebuild even when cv.tex is unchanged: the header is \today,
# so rebuilding is what refreshes the printed date.
latexmk -pdf -g -interaction=nonstopmode -halt-on-error cv.tex

mkdir -p docs
cp cv.pdf docs/cv.pdf

printf '\n'
grep -E "Output written" cv.log || true
printf 'over/underfull boxes: %s\n' "$(grep -cE "Overfull|Underfull" cv.log || true)"
