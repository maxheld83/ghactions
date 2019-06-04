FROM maxheld83/base

LABEL "name"="document"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="Document R Packages"
LABEL "com.github.actions.description"="Document Packages for rstats."
LABEL "com.github.actions.icon"="book-open"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages(pkgs = 'devtools')"
RUN Rscript -e "install.packages(pkgs = 'roxygen2')"

COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]

ENV R_LIBS="$R_LIBS_WORKFLOW"
