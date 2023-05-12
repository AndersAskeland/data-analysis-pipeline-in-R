#' Adds data field to metadata file.
#'
#' @param ... Additional parameters. Supports: Column names.
#' @param path str | CSV file containing metadata (default: "metadata.csv").
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
add_metadata <- function(..., path = here::here("metadata.csv")) {

  # Collect dynamic dots (...)
  dots <- rlang::list2(...)

  # Extract data
  columns <- tibble::as_tibble(dots)

  # Read metadata
  metadata <- readr::read_csv(path,
                              col_types = readr::cols(.default = "c"))

  # Extract constants
  constants <- metadata %>%
    dplyr::select(constant) %>%
    dplyr::pull()

  # Check if constant exists
  if(columns$constant %in% constants){
    stop(glue::glue("Constant {columns$constant} already present in data file.\\n Delete row with 'rm_metadata()' before attempting again."))
  }

  # Append data
  metadata %>%
    dplyr::rows_append(columns) %>%
    readr::write_csv(file = path,
                     na = NA_character_)

  # Give status
  cli::cli_alert_success("Added the following parameters to the metadata:")
  cli::cli_ul(columns)
}
