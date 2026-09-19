#!/usr/bin/env Rscript
#
# Universal project bootstrap script.
#
# Run this once after cloning or creating a new project from this template.
# It is editor-agnostic: it works identically from a plain terminal
# (`Rscript setup.R`), a VS Code integrated terminal / R terminal, or an
# RStudio console (`source("setup.R")`). It is also safe to re-run; every
# step checks current state before making changes.
#
# What it does:
#   1. Installs `usethis` and `renv` if they are not already available.
#   2. Creates or confirms the `.Rproj` file used by both VS Code (R
#      extension working-directory detection) and RStudio (project root).
#   3. Creates the standard project directories.
#   4. Adds data-science-friendly rules to `.gitignore`.
#   5. Initializes `renv` for reproducible, isolated dependency management.

message("== R Project Template Setup ==")

project_root <- getwd()
message("Using project root: ", project_root)

# 1. Bootstrap the packages this script itself depends on.
bootstrap_packages <- c("usethis", "renv")
missing_packages <- bootstrap_packages[
  !vapply(bootstrap_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages) > 0) {
  message("Installing setup dependencies: ", paste(missing_packages, collapse = ", "))
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
}

usethis::proj_set(project_root, force = TRUE)

# 2. Create or confirm the .Rproj file (root marker for VS Code and RStudio).
has_rproj <- length(list.files(project_root, pattern = "\\.Rproj$")) > 0
if (has_rproj) {
  message("Existing .Rproj file found - leaving it untouched.")
} else {
  message("Creating .Rproj file ...")
  usethis::use_rstudio()
}

# 3. Create standard project directories.
project_dirs <- c(
  "R",
  "data/raw",
  "data/processed",
  "data/features",
  "outputs/plots",
  "tests/testthat"
)
for (dir_path in project_dirs) {
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
    message("Created directory: ", dir_path)
  }
}

# 4. Data-science-oriented .gitignore rules, including local editor settings.
usethis::use_git_ignore(c(
  "data/raw/",
  ".Rhistory",
  ".RData",
  ".Rproj.user/",
  ".env",
  ".vscode/",
  ".DS_Store"
))

# 5. Reproducible, isolated dependency management.
if (dir.exists("renv") || file.exists("renv.lock")) {
  message("renv already initialized - skipping renv::init(). Run renv::restore() to sync packages.")
} else {
  message("Initializing renv ...")
  renv::init()
}

message("Setup complete. Restart your R session/terminal so the renv-activated .Rprofile takes effect.")
