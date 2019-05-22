#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

echo "Starting dependency installation ..."

if [ $# -eq 0 ]
  then
    Rscript /install.R
  else
    echo "Running custom commands ..."
    sh -c "$*"
fi
