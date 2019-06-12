FROM maxheld83/r-ci:93f4a98

LABEL "name"="GitHub actions base image"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

# location for R libraries which should persist across the entire workflow (i.e. several actions)
ENV R_LIBS_WORKFLOW="/github/home/lib/R/library"
RUN mkdir -p "$R_LIBS_WORKFLOW"
# location for R libraries which should persist only for this action
ENV R_LIBS_ACTION="$R_LIBS_DEV_HELPERS"

# system dependency of ghaction
RUN apt-get update \
  && apt-get install -y --no-install-recommends \ 
  git \
  && apt-get clean -y

ENV R_LIBS="$R_LIBS_ACTION"
# copy dependencies from earlier run of install_deps, must have *entire* /github in build context
# this will bake whatever the current dependencies in DESCRIPTION are into the image
COPY ./home/lib/R/library "$R_LIBS_ACTION"
# same here
COPY ./workspace /ghactions-source
# TODO this needs to be purged from the img via rm or multi-stage build
RUN Rscript -e "devtools::install(pkg = '/ghactions-source', dependencies = TRUE)"

# let downstream img start with unchanged env vars
# ... and without installed dev helpers on `.libPaths()`
# unset does not work https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
ONBUILD ENV R_LIBS=""
