FROM maxheld83/base

LABEL "com.github.actions.name"="Build R Packages"
LABEL "com.github.actions.description"="Build Packages for rstats."
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages(c('pkgbuild'))"

ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
