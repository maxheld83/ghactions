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

# remotes and curl need openssl
# TODO would be cleaner to get these via sysreqsdb package
RUN apt-get update \
  && apt-get install -y --no-install-recommends \ 
  libssl-dev \
  && apt-get clean -y

ENV R_LIBS="$R_LIBS_ACTION"
# bootstrap versioned remotes
RUN Rscript -e "source('https://raw.githubusercontent.com/r-lib/remotes/master/install-github.R')[['value']]('r-lib/remotes@v2.0.4')"
RUN Rscript -e "install.packages('remotes')"
# versions are hard-coded so as to *explicitly* upgrade pkgs, which will also invalidate the github cache
# without hard-coded versions, the below cache would *not* be invalidated and hard-to-reason about versions of the packages might still be lying around in the image
# necessary to let remotes install its helpers as per https://remotes.r-lib.org
ENV R_REMOTES_STANDALONE=true
RUN Rscript -e "remotes::install_version('curl', '3.3')"
RUN Rscript -e "remotes::install_version('pkgbuild', '1.0.3')"
RUN Rscript -e "remotes::install_version('git2r', '0.25.2')"

ENV R_LIBS="$R_LIBS_WORKFLOW"
COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
