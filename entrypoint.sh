#!/bin/sh

set -e

Rscript -e "remotes::install_deps(pkgdir = 'tests/testthat/descriptions/good', upgrade = 'always')"

echo "Completed dependency installation"
