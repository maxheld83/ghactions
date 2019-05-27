#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

echo "Building package ..."

Rscript -e "pkgbuild::build(path = '.', dest_path = '.')"
