#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

echo "Starting checks ..."

if [ ! -z "$R_LIBS_USER" ]
then
  echo "Using user library at $R_LIBS_USER ..."
fi

if [ $# -eq 0 ]
  then
    R CMD check
  else
    echo "Running custom commands ..."
    sh -c "$*"
fi
