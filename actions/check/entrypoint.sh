#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

echo "Building package ..."

if [ ! -z "$R_LIBS_USER" ]
then
  echo "Checking user library at $R_LIBS_USER..."
  if [ -d "$R_LIBS_USER" ]
  then
    echo "User library found at $R_LIBS_USER."
  else
    echo "No user library found at $R_LIBS_USER." 1>&2
    exit 2
  fi
fi

if [ $# -eq 0 ]
  then
    Rscript -e "rcmdcheck::rcmdcheck(error_on = 'warning')"
  else
    echo "Running custom commands ..."
    sh -c "$*"
fi
