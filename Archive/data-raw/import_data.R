#' Downloads the NHANES data and saves it as raw data.
#'
#' @param ... For compatibility with the targets pipeline.
#'
#' @return str | File path to data
#' @export
#'
#' @examples
#' get_raw_data()
get_raw_data <- function(...) {

  # Write data
  readr::write_csv(NHANES::NHANES, here::here("data-raw/nhanes.csv"))

  # Return file
  here::here("data-raw/nhanes.csv")
}
