#' Removes metadata from metadata fil
#'
#' @param remove str | Constant you want removed.
#' @param path str | Path to metadata (default: 'metadata.csv').
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
#' # Remove metadata
#' rm_metadata("BMI")
rm_metadata <- function(remove,
                        path = here::here("metadata.csv")) {

  # Read metadata
  metadata <- readr::read_csv(file = path,
                              col_types = "c")

  # Check if constant is in metadata
  if(!remove %in% metadata$constant){
    stop(glue::glue("Constant '{remove}' not in metadata."))
  }

  # Remove constant row
  metadata <- metadata %>%
    dplyr::filter(!constant == remove)

  # Write metadata
  readr::write_csv(metadata, path)

  # Give status
  cli::cli_alert_success("Removed the following parameter to the metadata:")
  cli::cli_ul(remove)
}
