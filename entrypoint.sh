#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

echo "Starting dependency installation ..."

if [ ! -z "$R_LIBS_USER" ]
then
  # R user library directories must exist before they can be used 
  echo "Creating user library directory at $R_LIBS_USER ..."
  mkdir -p "$R_LIBS_USER"
fi

if [ $# -eq 0 ]
  then
    Rscript --verbose -e "remotes::install_deps(dependencies = TRUE)"
  else
    echo "Running custom commands ..."
    sh -c "$*"
fi

echo "Completed dependency installation."
