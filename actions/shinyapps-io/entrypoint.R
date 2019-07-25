#!/usr/bin/env Rscript

rsconnect::setAccountInfo(
  name = Sys.getenv("SHINYAPPSIO_NAME"),
  token = Sys.getenv("SHINYAPPSIO_TOKEN"),
  secret = Sys.getenv("SHINYAPPSIO_SECRET")
)

# TODO pass on arguments from script here
rsconnect::deployApp()
