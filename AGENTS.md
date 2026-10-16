# AGENTS.md

This file provides guidance to coding agents (Codex, Claude Code) when working with code in this repository.

## What this is

LaTeX source of Trench's _Elementary Differential Equations with Boundary Value Problems_, restyled but with the original author's content (CC BY-NC-SA 3.0, see README). There is no application code or test suite; "testing" a change means building the PDF and checking that it is correct.

## Build

All TeX runs inside a pinned TeX Live container through `texlive.sh` (podman); there is no local TeX install. It must be run from inside the repo.

- `make book` builds `build/TRENCH_DIFFEQ_BV.pdf`.
- `make chapters` splits the book PDF into `build/chapters/NN.pdf` via `scripts/split-chapter-pdfs.py`, which finds chapter boundaries from the `chapter.N` PDF destinations and the `integrals` hypertarget. Keep both when changing headings.
- `make all` does both; `make clean` removes `build/` (git-ignored).
- The pipeline is `latex` -> `dvips` -> PDF (`latexmk -pdfps`), with EPS figures in `book/figures/`. `SOURCE_DATE_EPOCH=0` keeps output reproducible.
- If latexmk reports a stale error after a fix, delete `build/TRENCH_DIFFEQ_BV.fdb_latexmk`.
- The Makefile does not use `-f`; any LaTeX error fails the build, but undefined references and overfull boxes only appear in `build/TRENCH_DIFFEQ_BV.log`. Check the log for `Reference ... undefined`, `multiply defined` and `Missing character` after a build.

## Verifying changes

For refactors that must not change the book, build the old and new trees separately (e.g. `git archive HEAD book` into `tmp/`, which is git-ignored, and build with `-outdir`), then compare `pdftotext -layout` output and the `.toc`, `.out` and `.aux` label lines. Note that `pdftotext` renders "fi" as the ligature "ﬁ", so grep for e.g. "Deﬁnition".

## Python scripts

Use `uv` for any Python script, including throwaway checks (e.g. `uv run --with sympy script.py`, or `uv run script.py` with a PEP 723 inline dependency block). Never install packages globally (no system-wide `pip install`, no `--break-system-packages`) and do not create ad-hoc virtualenvs by hand.

## Source layout (`book/`)

- `TRENCH_DIFFEQ_BV.tex` is the only document; it inputs `preamble`, `frontmatter`, each `chapters/NN/chapter`, then `backmatter`.
- `preamble.tex` holds packages and settings; `macros.tex` holds all custom macros and environments, grouped by purpose. Prefer standard LaTeX/default styling; only add a macro when the sources need it.
- `chapters/NN/` holds `chapter.tex` (the `\chapter`, intro and `\input` lines for its sections), one `N.M.tex` per section, and the matching `N.M-answers.tex`. Sections 1.1, 1.3 and 8.8 have no answers file.
- `backmatter.tex` inputs `integrals.tex`, then every `chapters/NN/N.M-answers` in order (new answer files must be added here), then `index.tex`.
- Headings use standard `\chapter`/`\section`; the TOC is generated. `\exercises` (an "Exercises" subsection at the end of a section, listed in the TOC) and `\boxit{Title}` (an unnumbered subheading, bookmarked but not in the printed TOC) are the only custom heading macros.

## Conventions

- Cross-references use typed labels that encode the number: `eq:2.1.3`, `example:`, `exer:2.1.7`, `figure:`, `table:`, `thmtype:` (theorems and definitions). Answers (`\answer{2.1.7}`) and the index depend on these labels, so do not rename them. Put `\label` after `\caption`.
- Worked solutions of examples are wrapped in `examplesolution` (prints nothing), and an example without one is followed by a `% no solution` comment, so that scripts can collect examples with their solutions.
- Exercise lists use the `exerciselist`/`alist`/`rmlist` environments (enumitem); `\exercisetext{...}` interrupts a list and resumes numbering.
- `index.tex` is a hand-written `theindex` whose page numbers are `\pageref`s to labels, not `\index{}` markers.
- Formatting follows `.editorconfig` (2 spaces, 100 columns). Sources were formatted with Prettier and mathfmt.
- Blue text (`\color{blue}`) for defined terms and theorem bodies is intentional; red was removed.
