#!/bin/sh

set -e

# TODO it would be better to do as much as possible of this inside the dockerfile, not the entrypoint
# For R libraries to persist between github actions (though not across runs) they must be installed somewhere inside $HOME.
# this sets up R accordingly; all downstream actions using the same container must be set up in this way.
# R user library directories must exist before they can be used 
R_LIB_PATH="$GITHUB_WORKSPACE"/lib/R/library
mkdir -p "$R_LIB_PATH"
echo R_LIBS_USER="$R_LIB_PATH" >> "$HOME"/.Renviron

cat "$HOME"/.Renviron
echo "$HOME"

Rscript -e "remotes::install_deps(pkgdir = 'tests/testthat/descriptions/good', upgrade = 'always')"

ls -a "$R_LIB_PATH"

Rscript -e ".libPaths()"
Rscript -e "Sys.getenv(\"R_LIBS_USER\")"
echo "Completed dependency installation"
