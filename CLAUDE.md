# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A single-source LaTeX CV for Erik Fredner. `cv.tex` is the **short/typeset CV** — a curated, selective document (note the "Selected Publications / Awards / Presentations / Teaching" headings). The **full CV** lives elsewhere, as HTML at <https://fredner.org/cv.html>, and is not maintained in this repo. Do not try to make `cv.tex` comprehensive; entries are chosen for brevity.

`cv.pdf` is the build output but is **committed to the repo** — it is the artifact people link to. Rebuild and commit it whenever `cv.tex` changes, or the PDF goes stale.

## Build

```sh
latexmk -pdf cv.tex     # preferred; handles reruns for hyperref/titlesec
pdflatex cv.tex         # engine actually used for the committed PDF (pdfTeX/TeX Live)
```

Build twice with bare `pdflatex` so `\titlerule` placement and hyperref anchors settle. Stick with pdfLaTeX: the preamble uses `[T1]{fontenc}` + `ebgaramond`, which is a pdfTeX-style font setup, not fontspec/XeTeX.

Sanity checks after a build: `grep -E "Overfull|Underfull|Output written" cv.log`. A couple of Overfull warnings are normal here; a jump in their count usually means a long title or URL needs rewording.

Aux files (`cv.aux`, `cv.log`, `cv.out`, `cv.synctex.gz`) are build litter and are ignored — don't commit them.

## .gitignore is an allowlist

```
*
!cv.tex
!README.md
!CLAUDE.md
!.gitignore
```

Everything is ignored except explicitly listed files. (`LICENSE` and `cv.pdf` are tracked because git already tracked them before the allowlist.) Any **new** file you want tracked must either be added to that allowlist or force-added (`git add -f`). `cv.pdf` predates the allowlist and stays tracked because git already tracks it — but a fresh clone that regenerates it would need `-f`.

## Conventions in cv.tex

- **Structure is flat and hand-rolled.** No CV class or bibliography tooling — no `.bib`, no BibTeX/biber. Publications are hand-typed inside `\pubentry{...}`, a custom macro (defined in the preamble) that hanging-indents an entry by 1.5em. Two-column "thing … year" lines (Appointments, Education, Awards, Teaching) use plain text with `\hfill <year>` and `\\` line breaks instead.
- **Sections are marked by `%--- NAME ---` comments** above each `\section{}`. Keep that comment convention when adding a section.
- **Ordering is reverse-chronological within every section**, with `forthcoming` / `in preparation` items first.
- **Citations follow a fixed shape**: `Author(s), ``Title,'' \textit{Venue} vol.issue: pages, year. \url{https://doi.org/...}`. Use TeX quotes (` `` ` and `''`), `--` for year and page ranges, and prefer a DOI URL over a publisher link. Items not yet assigned a DOI simply omit the `\url{}`.
- **The header date is `\today`**, so the PDF stamps its own build date. Rebuilding is what refreshes it.
- Escape stray characters the usual LaTeX way; note the existing `'\,'` kern trick in the Hamlin Garland entry for a quote-inside-quote.

## Editing workflow

Content edits are the whole job here: add or move an entry, rebuild, commit both `cv.tex` and `cv.pdf`. Commit messages in this repo are short and plain ("add service", "update affiliation", "copyedits and url fixes").
