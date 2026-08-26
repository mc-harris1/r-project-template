# R Project Template

A small, opinionated starting point for R projects that process data in
repeatable stages. The template keeps project orchestration, shared helpers,
and directory conventions separate from domain-specific work.

## Structure

```text
.
├── main.R
├── R/
│   ├── stage_0_load.R
│   ├── stage_1_process.R
│   ├── stage_2_analyze.R
│   └── utils_shared.R
├── data/
│   ├── raw/          # User-provided or downloaded inputs
│   ├── processed/    # Intermediate data products
│   └── features/     # Derived features ready for analysis
└── outputs/
	 └── plots/        # Generated figures and reports
```

The data and output directories are ignored by Git. Their `.gitkeep` files
only preserve the initial project layout; replace them with real files as the
project develops.

## Getting started

1. Install R. The initial skeleton uses base R and has no required package
	installation step.
2. Put source files in `data/raw/` or replace the loader stage with the
	appropriate download or import code.
3. Run the complete pipeline from the repository root:

```r
source("main.R")
```

Optional dependencies can be managed with `renv`. Run `renv::init()` in the
project root when the project has a stable package set, then commit the
resulting lockfile.

## Pipeline stages

`main.R` sources the stages in order. Stage 0 must set `stage0_updated` to
`TRUE` when it creates or receives new input. The default skeleton sets it to
`TRUE` so the full example run is visible.

| Stage | Script | Responsibility |
| --- | --- | --- |
| 0 | `R/stage_0_load.R` | Load or acquire raw input and record whether it changed. |
| 1 | `R/stage_1_process.R` | Clean, transform, and save intermediate data. |
| 2 | `R/stage_2_analyze.R` | Create features, analyses, plots, or reports. |

Replace the placeholder behavior in each stage while keeping paths relative
to the project root. Add project-specific helpers to `R/utils_shared.R` only
when they are shared by multiple stages.

## Configuration

`.Rprofile` enables a useful `renv` setting when `renv` is present. `.lintr`
contains a lightweight linting configuration, and `.vscode/settings.json`
disables automatic R language-server installation prompts.

This template intentionally contains no data source, statistical method, or
domain-specific analysis. A financial-market workflow such as
`tda-financial-markets` can serve as an example of how to specialize these
stages, but its data, dependencies, and analysis code do not belong here.