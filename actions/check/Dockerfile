FROM ghactions/base

LABEL "com.github.actions.name"="Run Checks"
LABEL "com.github.actions.description"="Run R CMD check for rstats."
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages(pkgs = 'rcmdcheck')"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ENV R_LIBS="$R_LIBS_WORKFLOW"
