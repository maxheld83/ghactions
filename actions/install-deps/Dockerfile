FROM maxheld83/r-ci:4b9cbed

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
ENV R_LIBS_ACTION="$R_LIBS_DEV_HELPERS"
RUN mkdir -p "$R_LIBS_ACTION"
ENV R_LIBS_ACTION="$R_LIBS_ACTION"

# remotes and curl need openssl
# TODO would be cleaner to get these via sysreqsdb package
RUN apt-get update \
  && apt-get install -y --no-install-recommends \ 
  libssl-dev \
  && apt-get clean -y

ENV R_LIBS="$R_LIBS_WORKFLOW"
COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
