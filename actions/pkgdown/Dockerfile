ARG VERSION=latest
FROM maxheld83/ghactions:$VERSION

LABEL "name"="pkgdown"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="Create Documentation Website"
LABEL "com.github.actions.description"="Create website for rstats packages with pkgdown."
LABEL "com.github.actions.icon"="layout"
LABEL "com.github.actions.color"="blue"

# pkgdown uses a new rsession and therefore needs persistent R_LIBS, see https://github.com/r-lib/ghactions/issues/247
ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
