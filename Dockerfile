# Install R
FROM rocker/verse:4.2.3

# Install curl & openssl
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev libfribidi-dev libharfbuzz-dev  \
    libssl-dev libfontconfig1-dev libfreetype6-dev libpng-dev \
    libtiff5-dev libjpeg-dev libxml2-dev

# Install renv
RUN Rscript -e 'install.packages("renv")'

# Copy renv files
WORKDIR /project
COPY renv.lock renv.lock
COPY renv/ renv/

# Set renv lib path
ENV RENV_PATHS_LIBRARY renv/library

# Restore renv
RUN R -e "renv::restore()"

# Copy remaining files
COPY _targets.R _targets.R
COPY DESCRIPTION DESCRIPTION
COPY metadata.csv metadata.csv
COPY NAMESPACE NAMESPACE
COPY run.R run.R

# Copy r project file (This might be different for you!)
COPY reproducible-data-analysis.Rproj reproducible-data-analysis.Rproj


# Copy remaining folders
COPY ./data data/
COPY ./data-raw data-raw/
COPY ./doc doc/
COPY ./R R/
COPY ./man man/

# Run targets
CMD R -e "list.files('doc')"
CMD R -e "targets::tar_make()"




