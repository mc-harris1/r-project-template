# Shared helpers for pipeline scripts.

ensure_dir_exists <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  invisible(path)
}

build_data_path <- function(stage, filename) {
  file.path("data", stage, filename)
}

read_csv_data <- function(path) {
  if (!file.exists(path)) {
    stop(paste("File not found:", path))
  }
  read.csv(path, na.strings = c("", "NA", "null"), stringsAsFactors = FALSE)
}

standardize_date_column <- function(data) {
  date_col <- grep("(?i)date", names(data), value = TRUE, perl = TRUE)
  if (length(date_col) == 0) {
    stop("No date column found.")
  }
  names(data)[match(date_col[1], names(data))] <- "Date"
  data$Date <- as.Date(data$Date)
  data
}

save_plot <- function(plot, filename, width = 12, height = 8, dpi = 300) {
  ensure_dir_exists(dirname(filename))
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("save_plot requires the ggplot2 package.")
  }
  ggplot2::ggsave(
    filename,
    plot = plot,
    width = width,
    height = height,
    dpi = dpi
  )
}

log_message <- function(message) {
  cat(sprintf("[%s] %s\n", format(Sys.time(), "%H:%M:%S"), message))
}

get_last_date_from_csv <- function(path, date_col = "Date") {
  if (!file.exists(path)) {
    return(as.Date(NA))
  }
  data <- read_csv_data(path)
  if (!date_col %in% names(data)) {
    stop(paste("Date column not found:", date_col))
  }
  dates <- as.Date(data[[date_col]])
  if (length(dates) == 0 || all(is.na(dates))) {
    return(as.Date(NA))
  }
  max(dates, na.rm = TRUE)
}

read_state <- function(path) {
  if (!file.exists(path)) {
    return(list())
  }
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("read_state requires the jsonlite package.")
  }
  jsonlite::fromJSON(path, simplifyVector = FALSE)
}

write_state <- function(path, state) {
  ensure_dir_exists(dirname(path))
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("write_state requires the jsonlite package.")
  }
  jsonlite::write_json(state, path, auto_unbox = TRUE, pretty = TRUE)
}

resolve_last_date <- function(key, raw_path, state) {
  csv_date <- get_last_date_from_csv(raw_path)
  state_date <- if (!is.null(state[[key]])) as.Date(state[[key]]) else as.Date(NA)
  dates <- c(csv_date, state_date)
  if (all(is.na(dates))) {
    return(as.Date(NA))
  }
  max(dates, na.rm = TRUE)
}