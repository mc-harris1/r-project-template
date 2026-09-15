source("R/utils_shared.R")

source("R/stage_0_load.R")

if (!stage0_updated) {
  log_message("No new input - skipping processing and analysis stages.")
} else {
  source("R/stage_1_process.R")
  source("R/stage_2_analyze.R")
}
