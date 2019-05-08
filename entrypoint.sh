#!/bin/sh

set -e

# For R libraries to persist between github actions (though not across runs) they must be installed somewhere inside $HOME. (see https://github.com/maxheld83/ghactions-inst-rdep/issues/10)
# hypothesis: $HOME does not exist at build time of this image, but only at run time, when the github actions runner maps this volume (or whatever) https://github.com/maxheld83/ghactions-install-deps/issues/14.
# R user library directories must exist before they can be used 
# mkdir -p "$R_LIBS_USER"

Rscript -e "remotes::install_deps(pkgdir = 'tests/testthat/descriptions/good', upgrade = 'always')"

echo "this is ghactions-install-deps talking"
Rscript -e ".libPaths()"
Rscript -e "Sys.getenv(\"R_LIBS_USER\")"
echo "Completed dependency installation"
