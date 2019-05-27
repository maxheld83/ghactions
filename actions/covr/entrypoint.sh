#!/bin/sh

set -o errexit  # exit on any non-zero status
set -o nounset  # exit on unset vars

echo "Running test coverage ..."

Rscript -e "covr::codecov(quiet = FALSE, commit = '$GITHUB_SHA', branch = '$GITHUB_REF')"
