FROM rhub/debian-gcc-release:latest
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

# system dependencies for frequently used R development helper Packages
# required for devtools, covr and more
# required for pkgdown, roxygen2
RUN apt-get update && \
  apt-get install -y --no-install-recommends \ 
  libssl-dev \
  libxml2-dev && \
  apt-get clean -y

# location for R libraries which should persist across the entire workflow (i.e. several actions)
ARG R_LIBS_WORKFLOW="/github/home/lib/R/library"
RUN mkdir -p "$R_LIBS_WORKFLOW"
ENV R_LIBS_WORKFLOW="$R_LIBS_WORKFLOW"
# location for R libraires which should persist only for this action
ARG R_LIBS_ACTION="/usr/lib/R/action-library"
RUN mkdir -p "$R_LIBS_ACTION"
ENV R_LIBS_ACTION="$R_LIBS_ACTION"
