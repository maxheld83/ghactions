#!/bin/sh

set -eu

# R user library directories must exist before they can be used 
mkdir -p "$R_LIBS_USER"

Rscript -e "remotes::install_deps(pkgdir = 'tests/testthat/descriptions/good', upgrade = 'always')"

echo "this is ghactions-install-deps talking"
Rscript -e ".libPaths()"
Rscript -e "Sys.getenv(\"R_LIBS_USER\")"
echo "Completed dependency installation"
