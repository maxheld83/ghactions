#!/bin/sh

set -e

echo "this is ghactions_check talking"

Rscript -e ".libPaths()"
Rscript -e "Sys.getenv(\"R_LIBS_USER\")"

sh -c "Rscript -e '$*'"
