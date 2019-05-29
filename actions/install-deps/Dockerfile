FROM maxheld83/base

LABEL "com.github.actions.name"="Install R Package Dependencies"
LABEL "com.github.actions.description"="Install Package Dependencies for rstats."
LABEL "com.github.actions.icon"="arrow-down-circle"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages(pkgs = 'remotes', lib = Sys.getenv('R_LIBS_ACTION'))"

COPY entrypoint.R /entrypoint.R
ENTRYPOINT ["/entrypoint.R"]
