ARG VERSION=latest
FROM maxheld83/ghactions:$VERSION

LABEL "name"="covr"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="Measure Test Coverage"
LABEL "com.github.actions.description"="Measure test coverage using covr."
LABEL "com.github.actions.icon"="pie-chart"
LABEL "com.github.actions.color"="blue"

# pkgdown uses a new rsession and therefore needs persistent R_LIBS, see https://github.com/r-lib/ghactions/issues/247
ENV R_LIBS="$R_LIBS_ACTION:$R_LIBS_WORKFLOW"

COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
