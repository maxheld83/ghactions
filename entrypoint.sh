#!/bin/sh

set -e

Rscript -e "remotes::install_cran('dplyr')"

echo "Hello world"
