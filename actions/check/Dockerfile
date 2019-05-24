FROM maxheld83/ghactions

LABEL "com.github.actions.name"="Run Checks"
LABEL "com.github.actions.description"="Run R CMD check for rstats."
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="blue"

# bake testthat into image, but do not let it persist across actions
RUN Rscript -e "install.packages(c('testthat', 'rcmdcheck'))"

# use persistent library
ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
