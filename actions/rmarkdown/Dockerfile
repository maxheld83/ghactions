FROM rocker/verse:3.5.1

LABEL "name"="rmarkdown"
LABEL "version"="0.1.1.9000"
LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="RMarkdown"
LABEL "com.github.actions.description"="Render RMarkdown Projects."
LABEL "com.github.actions.icon"="pen-tool"
LABEL "com.github.actions.color"="orange"

# TODO might be pasted in from build command actually, reduce duplication
ARG R_LIBS_WORKFLOW="/github/home/lib/R/library/"

# set shell to Rscript to make syntax shorter
SHELL ["usr/local/bin/Rscript", "-e"]

# needed for presentations
RUN remotes::install_github(repo = 'maxheld83/rmdshower', ref = '3ae169f')

# location for R libraries which should persist across the entire workflow (i.e. several actions)
ENV R_LIBS="R_LIBS_WORKFLOW"

COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
