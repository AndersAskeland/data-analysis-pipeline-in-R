#' Extracts metadata
#'
#' @param columns str | Column or vector of columns you want to extract
#' @param path str | Parh to metadata. Default: "here::here("metadata.csv)"
#' @param col_type str | Type of data. Default: "NULL"
#'
#' @return Tibble with extracted metadata.
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
#' # Extract metadata
#' extract_metadata("BMI")
extract_metadata <- function(columns, path = here::here("metadata.csv"), col_type = NULL) {

  # Read data
  metadata <- readr::read_csv(path,
                              col_types = readr::cols(.default = "c"))

  # Extract everything
  if(is.null(col_type)) {
    data <- metadata %>%
      dplyr::select(dplyr::all_of(columns))
  } else {
    # Extract specific field
    data <- metadata %>%
      dplyr::filter(type == {{ col_type }}) %>%
      dplyr::select(dplyr::all_of(columns))
  }

  # Return
  data
}
