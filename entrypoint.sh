#!/bin/sh

set -e

Rscript -e ".libPaths()"
Rscript -e "Sys.getenv(\"R_LIBS_USER\")"

sh -c "Rscript -e '$*'"
