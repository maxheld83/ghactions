FROM maxheld83/ghactions

LABEL "com.github.actions.name"="Measure Test Coverage"
LABEL "com.github.actions.description"="Measure test coverage using covr."
LABEL "com.github.actions.icon"="pie-chart"
LABEL "com.github.actions.color"="blue"

# required for covr
RUN apt-get install -y --no-install-recommends libssl-dev

RUN Rscript -e "install.packages(c('covr'))"

ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
