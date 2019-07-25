FROM rocker/r-verse:latest


# location for R libraries which should persist across the entire workflow (i.e. several actions)
# this directory and its (potential) content must be created by running action install-deps first see #275
ENV R_LIBS_WORKFLOW="/github/home/lib/R/library/"

# install some R packages
RUN Rscript -e "install.packages(pkgs = c('rsconnect')"

LABEL "name"="check"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="Deploy to shinyapps.io"
LABEL "com.github.actions.description"="Talk to shinyapps.io via rsconnect"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
