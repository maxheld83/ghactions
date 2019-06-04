FROM maxheld83/base

LABEL "name"="install-deps"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="Install R Package Dependencies"
LABEL "com.github.actions.description"="Install Package Dependencies for rstats."
LABEL "com.github.actions.icon"="arrow-down-circle"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages(pkgs = c('curl', 'pkgbuild', 'git2r', 'remotes', 'withr'), lib = Sys.getenv('R_LIBS_ACTION'))"

COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]

ENV R_LIBS="$R_LIBS_WORKFLOW"
