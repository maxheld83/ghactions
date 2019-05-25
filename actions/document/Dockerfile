FROM maxheld83/ghactions

LABEL "com.github.actions.name"="Document R Packages"
LABEL "com.github.actions.description"="Document Packages for rstats."
LABEL "com.github.actions.icon"="book-open"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages(c('devtools'))"

ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
