#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

echo "Building package website..."

Rscript -e "pkgdown::build_site(override = list(devel = F, external = F))"
