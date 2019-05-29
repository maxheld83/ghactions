FROM ghactions/base

LABEL "com.github.actions.name"="Install R Package"
LABEL "com.github.actions.description"="Install R package."
LABEL "com.github.actions.icon"="play-circle"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages('devtools')"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ENV R_LIBS="$R_LIBS_WORKFLOW"
