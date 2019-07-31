FROM maxheld83/r-ci:d2a3a47

LABEL "name"="GitHub actions base image"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

# location for R libraries which should persist across the entire workflow (i.e. several actions)
# this directory and its (potential) content must be created by running action install-deps first see #275
ENV R_LIBS_WORKFLOW="/github/home/lib/R/library/"
# location for R libraries which should persist only for this action
ENV R_LIBS_ACTION="$R_LIBS_DEV_HELPERS"

# system dependency of ghaction
RUN apt-get update --allow-releaseinfo-change \
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

# install docker
# remove this and do it automatically via sysdeps
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh

ENV R_LIBS="$R_LIBS_WORKFLOW:$R_LIBS_ACTION"
