FROM maxheld83/ghactions
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "com.github.actions.name"="Install R Package Dependencies"
LABEL "com.github.actions.description"="Install Package Dependencies for rstats."
LABEL "com.github.actions.icon"="arrow-down-circle"
LABEL "com.github.actions.color"="blue"

RUN apt-get install -y --no-install-recommends libssl-dev

ENV R_LIBS="$R_LIBS_ACTION"
# curl and git2r speed up pkg installation as per docs https://remotes.r-lib.org/index.html
RUN Rscript -e "install.packages(c('remotes', 'curl', 'git2r', 'pkgbuild'))"

# now set R_LIBS to persistent folder
ENV R_LIBS="$R_LIBS_WORKFLOW"

COPY install.R /install.R
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
