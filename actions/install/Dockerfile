FROM maxheld83/ghactions

LABEL "com.github.actions.name"="Install R Package"
LABEL "com.github.actions.description"="Install R package."
LABEL "com.github.actions.icon"="play-circle"
LABEL "com.github.actions.color"="blue"

# required for devtools
RUN apt-get install -y --no-install-recommends libssl-dev

RUN Rscript -e "install.packages(c('devtools'))"

ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
