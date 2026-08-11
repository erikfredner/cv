# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A single-source LaTeX CV for Erik Fredner. `cv.tex` is the **short/typeset CV** — a curated, selective document (note the "Selected Publications / Awards / Presentations / Teaching" headings). The **full CV** lives elsewhere, as HTML at <https://fredner.org/cv.html>, and is not maintained in this repo. Do not try to make `cv.tex` comprehensive; entries are chosen for brevity.

The build output is **committed to the repo** as `docs/cv.pdf` — it is the artifact people link to, published via GitHub Pages at <https://fredner.org/cv/>. Rebuild and commit it whenever `cv.tex` changes, or the PDF goes stale.

## Build

```sh
./build.sh              # normal entry point: builds, then copies the PDF to docs/
latexmk -pdf cv.tex     # underlying build; handles reruns for hyperref/titlesec
pdflatex cv.tex         # engine actually used for the committed PDF (pdfTeX/TeX Live)
```

`build.sh` runs `latexmk -pdf -g` (the `-g` forces a rebuild even when `cv.tex` is unchanged, so the `\today` header date refreshes), copies `cv.pdf` to `docs/cv.pdf`, and prints the page count plus the over/underfull box count. Running `latexmk` or `pdflatex` by hand leaves the root `cv.pdf` updated but `docs/cv.pdf` stale — that is the copy that gets published.

## GitHub Pages

Pages serves this repo from `main` + `/docs`, so `docs/cv.pdf` is live at <https://fredner.org/cv/cv.pdf>. Pages sends it as `application/pdf` with no `Content-Disposition`, so it opens in the browser's built-in viewer; `raw.githubusercontent.com` sends `application/octet-stream` and forces a download, so don't link that. `docs/index.html` is a meta-refresh redirect so the bare <https://fredner.org/cv/> lands on the PDF, and `docs/.nojekyll` tells the legacy Pages builder to publish `docs/` verbatim. Only the PDF is copied into `docs/` — never the `.log`/`.aux`, which would be publicly served.

Check a deploy with `gh api repos/erikfredner/cv/pages/builds/latest --jq .status` (expect `built`).

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
!build.sh
!docs/
!docs/cv.pdf
!docs/index.html
!docs/.nojekyll
```

Everything is ignored except explicitly listed files. (`LICENSE` is tracked because git already tracked it before the allowlist.) Any **new** file you want tracked must either be added to that allowlist or force-added (`git add -f`). Because the leading `*` matches at every level, a bare `!docs/` is not enough — each file under `docs/` needs its own negation.

The root `cv.pdf` is **untracked** build litter; `docs/cv.pdf` is the tracked artifact.

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

Content edits are the whole job here: add or move an entry, run `./build.sh`, commit both `cv.tex` and `docs/cv.pdf`. Commit messages in this repo are short and plain ("add service", "update affiliation", "copyedits and url fixes").
