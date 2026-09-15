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
├── tests/
│   └── testthat/     # Unit tests and shared test setup
├── scripts/          # Environment, lint, and formatting commands
├── uvr.toml          # Declared R and tooling dependencies
└── uvr.lock          # Resolved, reproducible package environment
└── outputs/
	 └── plots/        # Generated figures and reports
```

The data and output directories are ignored by Git. Their `.gitkeep` files
only preserve the initial project layout; replace them with real files as the
project develops.

## Getting started

Install the `uvr` CLI:

```sh
curl -fsSL https://raw.githubusercontent.com/nbafrank/uvr/main/install.sh | sh
```

Restart the shell if `~/.local/bin` is not already on `PATH`, then initialize
the project environment:

```sh
export UVR_LIBRARY="$HOME/.uvr/projects/r-project-template/library"
bash scripts/setup_uvr.sh
```

The setup pins R 4.6.1, resolves the dependencies in `uvr.toml`, and writes
the committed `uvr.lock`. Packages are installed outside the repository at
`~/.uvr/projects/r-project-template/library` by default. Set `UVR_LIBRARY`
before running setup to choose another local path.

Restore the committed environment on later checkouts with:

```sh
uvr sync --frozen
```

Keep `UVR_LIBRARY` exported when invoking `uvr` directly so package binaries
are not created in the repository's `.uvr/` directory.

Put source files in `data/raw/` or replace the loader stage with the
appropriate download or import code. Run the complete pipeline from the
repository root:

```sh
uvr run main.R
```

The baseline dependency set contains the test and quality tools plus packages
used by current template helpers. Add application-specific dependencies with
`uvr add <package>` and commit the resulting `uvr.toml` and `uvr.lock` changes.

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

`.Rprofile` activates the `uvr` library and checks the R version pin. `.lintr`
contains a lightweight linting configuration, and `.vscode/settings.json`
disables automatic R language-server installation prompts.

## Testing

Run the unit suite from the repository root:

```sh
uvr run tests/testthat.R
```

Tests use `tests/testthat/helper-load.R` to source the template's pipeline
scripts. Add project tests as `test-*.R` files in `tests/testthat/`.

## Code quality

Lint the R source:

```sh
uvr run scripts/lint.R
```

Format project-owned R source and tests before committing:

```sh
uvr run scripts/style.R
```

Install the repository hooks after installing the `pre-commit` CLI:

```sh
pre-commit install
```

`.pre-commit-config.yaml` applies tidyverse R styling, checks R syntax, blocks
`browser()` and `print()` statements, and enforces standard whitespace and
large-file checks. Generated `data/` and `outputs/` files are excluded from
the R-specific hooks.

GitHub Actions runs linting on every push and pull request. The quality-check
workflow runs the frozen `uvr` environment, linting, and `testthat` for pushes
and pull requests targeting `main`.

This template intentionally contains no data source, statistical method, or
domain-specific analysis. A financial-market workflow such as
`tda-financial-markets` can serve as an example of how to specialize these
stages, but its data, dependencies, and analysis code do not belong here.
