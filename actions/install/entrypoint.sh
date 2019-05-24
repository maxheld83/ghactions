#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

echo "Installing package ..."

Rscript -e "devtools::install()"
