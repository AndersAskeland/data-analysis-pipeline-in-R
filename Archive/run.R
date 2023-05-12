# Install renv
install.packages('renv', verbose = FALSE)

# Install all packages
renv::restore()

# Run workflow
targets::tar_make()
