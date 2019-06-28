FROM maxheld83/r-ci:7ae85a7

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
ENV R_LIBS_WORKFLOW="/github/home/lib/R/library/"
RUN mkdir --parents "$R_LIBS_WORKFLOW"

COPY ./ /test/
COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
