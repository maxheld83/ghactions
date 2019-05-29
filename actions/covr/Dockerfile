FROM ghactions/base

LABEL "com.github.actions.name"="Measure Test Coverage"
LABEL "com.github.actions.description"="Measure test coverage using covr."
LABEL "com.github.actions.icon"="pie-chart"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages(pkgs = 'covr')"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ENV R_LIBS="$R_LIBS_WORKFLOW"
