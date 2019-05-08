#!/bin/sh

set -e

echo "this is ghactions-check talking"

Rscript -e ".libPaths()"
Rscript -e "Sys.getenv(\"R_LIBS_USER\")"

sh -c "Rscript -e '$*'"
