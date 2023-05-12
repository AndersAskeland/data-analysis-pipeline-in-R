#' Writes metadata file into internal data.
#'
#' @param path str | Path to metadata file. Default: "metadata.csv".
#'
#' @return NA
#' @export
#'
#' @examples
#' # Create metadata
#' create_metadata("constant",
#'                 "column_name",
#'                 "display_name",
#'                 "col_type")
#'
#' # Add metadata
#' add_metadata(constant = BMI,
#'              column_name = BMI,
#'              display_name = "Body mass index (BMI)",
#'              col_type = "dbl")
#'
#' write_internal_data()
write_internal_data <- function(path = here::here("metadata.csv")) {

  # Read data
  metadata <- readr::read_csv(path,
                              col_types = readr::cols(.default = "c"))

  # Extract constants
  constants <- metadata %>%
    dplyr::select(constant) %>%
    dplyr::pull()

  # Extract column names
  colunm_name <- metadata %>%
    dplyr::select(column_name) %>%
    dplyr::pull()

  # Create new enviorment
  temp_env <- rlang::env()

  # Write to temp enviorment
  purrr::map2(colunm_name, constants, ~assign(.y, .x, envir = temp_env))

  # Save as sysdata
  save(list = constants, file = "R/sysdata.rda", envir = temp_env)

  # Give status
  cli::cli_alert_success("Wrote internal data!")

  # Reload if interactive
  if(interactive()) devtools::load_all()
}
