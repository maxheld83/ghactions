FROM maxheld83/ghactions

LABEL "com.github.actions.name"="Document R Packages"
LABEL "com.github.actions.description"="Document Packages for rstats."
LABEL "com.github.actions.icon"="book-open"
LABEL "com.github.actions.color"="blue"

# required for devtools
RUN apt-get install -y --no-install-recommends libssl-dev
RUN apt-get install -y --no-install-recommends libxml2-dev

RUN Rscript -e "install.packages(c('devtools', 'roxygen2'))"

ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
