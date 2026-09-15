test_that("ensure_dir_exists creates and returns a directory", {
  directory <- tempfile("r-project-template-")

  expect_false(dir.exists(directory))
  expect_identical(ensure_dir_exists(directory), directory)
  expect_true(dir.exists(directory))
})

test_that("build_data_path constructs stage-relative paths", {
  expect_identical(
    build_data_path("processed", "observations.csv"),
    file.path("data", "processed", "observations.csv")
  )
})

test_that("read_csv_data validates that its input exists", {
  expect_error(read_csv_data(tempfile("missing-")), "File not found")
})

test_that("standardize_date_column normalizes a date field", {
  input <- data.frame(record_date = "2026-01-02", value = 1)

  result <- standardize_date_column(input)

  expect_named(result, c("Date", "value"))
  expect_s3_class(result$Date, "Date")
  expect_equal(result$Date, as.Date("2026-01-02"))
  expect_error(standardize_date_column(data.frame(value = 1)), "No date column")
})

test_that("date helpers use the most recent available date", {
  csv_path <- tempfile(fileext = ".csv")
  utils::write.csv(
    data.frame(Date = c("2026-01-02", "2026-01-05")),
    csv_path,
    row.names = FALSE
  )

  expect_equal(get_last_date_from_csv(csv_path), as.Date("2026-01-05"))
  expect_equal(
    resolve_last_date("input", csv_path, list(input = "2026-01-08")),
    as.Date("2026-01-08")
  )
  expect_true(is.na(resolve_last_date("input", tempfile("missing-"), list())))
})

test_that("state helpers round trip JSON state", {
  state_path <- tempfile(fileext = ".json")
  state <- list(last_updated = "2026-01-05", records = 3)

  write_state(state_path, state)

  expect_equal(read_state(state_path), state)
  expect_equal(read_state(tempfile("missing-")), list())
})
