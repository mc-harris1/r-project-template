if (!requireNamespace("styler", quietly = TRUE)) {
  stop("Package 'styler' is required. Install it with install.packages('styler').")
}

styler::style_dir("R")
styler::style_dir("tests")
styler::style_file("main.R")
styler::style_file("scripts/lint.R")
styler::style_file("scripts/style.R")
