#' Creates metadata file that can be used to store various metadata inside.
#'
#' @param ... Additional parameters. Supports: Column names.
#' @param path str | Path to store metadata
#' @param overwrite bool | Overwrite old metadata (default = FALSE).
#' @param backup bool | Create backup of old metadata (default = TRUE)
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
create_metadata <- function(...,
                            path = here::here("metadata.csv"),
                            overwrite = FALSE,
                            backup = TRUE) {

  # Collect dynamic dots (...)
  dots <- rlang::list2(...)

  # Create backup
  if(backup == TRUE & fs::file_exists(path)){
    fs::file_copy(path,
                  new_path = paste0(fs::path_dir(path),
                                    "/backup_",
                                    Sys.Date(),
                                    "_",
                                    fs::path_file(path)),
                  overwrite = TRUE)
  }

  # Check if file exists
  if(fs::file_exists(path) & overwrite == FALSE){
    stop("File already exists. Overwrite with 'overwrite = TRUE'.")
  }

  # Columns
  columns <- append(c("constant", "type", "column_name"), dots) %>%
    unique()

  # Create metadata
  metadata <- tibble::as_tibble(matrix(nrow = 0,
                                       ncol = length(columns),
                                       dimnames = list(NULL, columns)))

  # Write metadata
  readr::write_csv(metadata,
                   file = path)

  # Give status
  cli::cli_alert_success("Created metadata file with the following parameters:")
  cli::cli_ul(columns)
}
