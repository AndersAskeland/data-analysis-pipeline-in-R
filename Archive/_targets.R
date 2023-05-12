# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(dplyr)
library(magrittr)
load("R/sysdata.rda")

# Set target options:
tar_option_set(
  packages = desc::desc_get_deps() %>%
    dplyr::filter(type == "Imports") %>%
    dplyr::select(package) %>%
    dplyr::pull(),
  format = "rds"
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
# Run the R scripts in the R/ folder with your custom functions:
tar_source()
source("data-raw/import_data.R")# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
# _targets.R #

list(
  # Step 1 - Write internal data
  tar_target(name = metadata,
             command = here::here("metadata.csv"),
             format = "file"),
  tar_target(name = write_sys_data,
             command = write_internal_data(metadata)),

  # 2 - Import raw data
  tar_target(name = raw_data,
             command = get_raw_data(metadata),
             format = "file"),

  # 3 - Read data
  tar_target(name = nhanes_df,
             command = readr::read_csv(raw_data)),

  # 4 - Clean data
  tar_target(name = clean_df,
             command = nhanes_df %>%
               dplyr::select(dplyr::all_of(c(DIABETES,
                                             EDUCATION,
                                             BMI)))),
  # 5 - Create visulizations
  tar_target(name = education_vs_bmi,
             command = clean_df %>%
               ggplot2::ggplot(ggplot2::aes(x = !!rlang::sym(EDUCATION),
                                            y = !!rlang::sym(BMI))) +
               ggplot2::geom_boxplot()),

  # 6 - Create reproducible document
  tar_quarto(name = report,
             path = "doc/report.qmd")
)
