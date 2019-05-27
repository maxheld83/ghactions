#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

echo "Checking package ..."

Rscript -e "rcmdcheck::rcmdcheck(error_on = 'warning')"
