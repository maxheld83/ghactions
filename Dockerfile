FROM rhub/debian-gcc-release
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/maxheld83/ghactions-inst-rdep"
LABEL "homepage"="http://github.com/maxheld83/ghactions-inst-rdep"

LABEL "com.github.actions.name"="Install R Package Dependencies"
LABEL "com.github.actions.description"="Install R Package Dependencies."
LABEL "com.github.actions.icon"="arrow-down-circle"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages('remotes')"
# above installation must happen before R library is set to persist in entrypoint.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
