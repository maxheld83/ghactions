#!/bin/sh

set -eu

if [ ! -z "$R_LIBS_USER" ]
then
  # R user library directories must exist before they can be used 
  mkdir -p "$R_LIBS_USER"
fi

if [ $# -eq 0 ]
  then
    Rscript -e "remotes::install_deps(dependencies = TRUE)"
  else
    sh -c "$*"
fi

echo "this is ghactions-install-deps talking"
Rscript -e ".libPaths()"
Rscript -e "Sys.getenv(\"R_LIBS_USER\")"
echo "Completed dependency installation"
