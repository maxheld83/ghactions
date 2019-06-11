FROM maxheld83/r-ci:88329f5

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

# add the dependencies of github actions
# these are hard-versioned here and *may differ* from the result you get from running `remotes::install_deps()` on `DESCRIPTION`.
# this is *intentional*, because hard-versioning is a safer way to bake dependencies into downstream action images
# it also lets us use the (apparently operational) GitHub actions docker layer cache
ENV R_LIBS="$R_LIBS_ACTION"
# everything from DESCRIPTION Imports: except what is already in r-ci
RUN Rscript -e "remotes::install_version('checkmate', '1.9.3')"
RUN Rscript -e "remotes::install_version('desc', '1.2.0')"
RUN Rscript -e "remotes::install_version('fs', '1.3.1')"
RUN Rscript -e "remotes::install_version('gh', '1.0.1')"
RUN Rscript -e "remotes::install_version('glue', '1.3.1')"
RUN Rscript -e "remotes::install_version('purrr', '0.3.2')"
RUN Rscript -e "remotes::install_version('readr', '1.3.1')"
RUN Rscript -e "remotes::install_version('rlang', '0.3.4')"
RUN Rscript -e "remotes::install_version('usethis', '1.5.0')"
RUN Rscript -e "remotes::install_version('whisker', '0.3-2')"
# only some necessary pkgs from DESCRIPTION Suggests: except what is already in r-ci
RUN Rscript -e "remotes::install_version('processx', '3.3.1')"

# this requires the pkg source to be in the build context!
COPY . /ghactions
# TODO this needs to be purged from the img via rm or multi-stage build
RUN Rscript -e "devtools::install(pkg = '/ghactions', dependencies = TRUE)"

# let downstream img start with unchanged env vars
# ... and without installed dev helpers on `.libPaths()`
# unset does not work https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
ONBUILD ENV R_LIBS=""
