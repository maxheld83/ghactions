FROM rhub/debian-gcc-release
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "name"="install-deps"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="Install R Package Dependencies"
LABEL "com.github.actions.description"="Install Package Dependencies for #rstats."
LABEL "com.github.actions.icon"="arrow-down-circle"
LABEL "com.github.actions.color"="blue"

# location for R libraries which should persist across the entire workflow (i.e. several actions)
ARG R_LIBS_WORKFLOW="/github/home/lib/R/library"
RUN mkdir -p "$R_LIBS_WORKFLOW"
ENV R_LIBS_WORKFLOW="$R_LIBS_WORKFLOW"
# location for R libraires which should persist only for this action
ARG R_LIBS_ACTION="/usr/lib/R/action-library"
RUN mkdir -p "$R_LIBS_ACTION"
ENV R_LIBS_ACTION="$R_LIBS_ACTION"

# system dependencies for frequently used R development helper Packages
# required for devtools, covr and more
# required for pkgdown, roxygen2
# git is necessary for doing and testing programmatic commits
RUN apt-get update \
  && apt-get install -y --no-install-recommends \ 
  libssl-dev \
  libxml2-dev \
  && apt-get clean -y

ENV R_LIBS="$R_LIBS_ACTION"
RUN Rscript -e "install.packages('remotes')"
RUN Rscript -e "remotes::install_cran('curl')"
RUN Rscript -e "remotes::install_cran('pkgbuild')"
RUN Rscript -e "remotes::install_cran('git2r')"
RUN Rscript -e "remotes::install_cran('withr')"

ENV R_LIBS="$R_LIBS_WORKFLOW"
COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
