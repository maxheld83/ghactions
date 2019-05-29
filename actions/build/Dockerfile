FROM ghactions/base

LABEL "name"="build"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="Build R Packages"
LABEL "com.github.actions.description"="Build Packages for rstats."
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages('pkgbuild')"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ENV R_LIBS="$R_LIBS_WORKFLOW"
