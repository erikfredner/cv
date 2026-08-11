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

**Every dependency is in TeX Live**, so the document builds anywhere with no font installation. Keep it that way. A system-installed font would mean `fontspec`, LuaLaTeX, absolute font paths, and a document only one machine can compile — this was tried with Helvetica Now and reverted as too fragile.

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

- **Structure is flat and hand-rolled.** No CV class or bibliography tooling — no `.bib`, no BibTeX/biber. There are two entry shapes, and only two:
  - **Prose entries** (Publications, Works in Progress, Presentations) are hand-typed inside `\pubentry{...}`, a custom macro (defined in the preamble) that hanging-indents by 1.5em. Successive `\pubentry` lines get 3pt of `\parskip` between them, because these entries usually run to two or more lines and need the separation.
  - **List entries** (Appointments, Education, Awards, Teaching) are plain text, one per line, ending in `\\` — no macro, no `\hfill`. They set tight (no inter-entry gap); wrapping them in `\pubentry` instead adds ~45pt overall and spills Teaching onto a third page.
- **List entries read `{thing}, {institution}, {years}.`** — comma-separated, closing period. `\hfill` right-aligned year columns were removed; don't reintroduce them.
- **Sections are marked by `%--- NAME ---` comments** above each `\section{}`. Keep that comment convention when adding a section.
- **Ordering is reverse-chronological within every section**, with `forthcoming` / `in preparation` items first.
- **Citations follow a fixed shape**: `Author(s), ``Title,'' \textit{Venue} vol.issue: pages, year. \url{https://doi.org/...}`. Use TeX quotes (` `` ` and `''`), `--` for year and page ranges, and prefer a DOI URL over a publisher link. Items not yet assigned a DOI simply omit the `\url{}`.
- **Year ranges in list entries are abbreviated**: `2021--24`, not `2021--2024`. Full four-digit years elsewhere (publication years, dates inside titles like `1984--2024`, which spans a century and must stay long). The ongoing appointment uses the open form, `2025--.`
- **URLs are set in the body font, not monospace** (`\urlstyle{same}`). Side effect: EB Garamond's oldstyle figures apply to digits in DOIs, and `url` suppresses kerning, so an `f` inside a URL shows a visible gap (`purl.stanf ord.edu`). Reverting to `\urlstyle{tt}` restores monospace and removes both.
- **No math mode for text glyphs.** The header separators use `\textperiodcentered{}` rather than `$\cdot$`; math mode would set the dot in Computer Modern rather than EB Garamond. Note the `{}` — without it the control word swallows the following space.
- **The header date is `\today`**, so the PDF stamps its own build date. Rebuilding is what refreshes it.
- Escape stray characters the usual LaTeX way; note the existing `'\,'` kern trick in the Hamlin Garland entry for a quote-inside-quote.

## Editing workflow

Content edits are the whole job here: add or move an entry, rebuild, commit both `cv.tex` and `cv.pdf`. Commit messages in this repo are short and plain ("add service", "update affiliation", "copyedits and url fixes").
