FROM maxheld83/ghactions

LABEL "com.github.actions.name"="Create Documentation Website"
LABEL "com.github.actions.description"="Create website for rstats packages with pkgdown."
LABEL "com.github.actions.icon"="layout"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages('pkgdown')"

ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
