#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

if [ ! -z "$R_LIBS_USER" ]
then
  # R user library directories must exist before they can be used 
  mkdir -p "$R_LIBS_USER"
fi

if [ $# -eq 0 ]
  then
    Rscript --verbose -e "remotes::install_deps(dependencies = TRUE)"
  else
    sh -c "$*"
fi

echo "this is ghactions-install-deps talking"
Rscript -e ".libPaths()"
Rscript -e "Sys.getenv(\"R_LIBS_USER\")"
echo "Completed dependency installation"
