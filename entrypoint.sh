#!/bin/sh

set -e

# TODO this is code duplication; would be better to only do this in the upstream container, perhaps by placing .renviron in workspace
R_LIB_PATH="$HOME"/lib/R/library
echo R_LIBS_USER="$R_LIB_PATH" >> "$HOME"/.Renviron

sh -c "Rscript -e '$*'"
