if (!requireNamespace("lintr", quietly = TRUE)) {
  stop("Package 'lintr' is required. Install it with install.packages('lintr').")
}

lints <- lintr::lint_dir("R")

if (length(lints) > 0L) {
  message(paste(utils::capture.output(lints), collapse = "\n"))
  quit(status = 1L)
}

message("No lint found.")
