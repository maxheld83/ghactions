#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

Rscript -e "pkgbuild::build(path = '.', dest_path = '.')"
