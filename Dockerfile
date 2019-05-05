FROM rhub/debian-gcc-release
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/maxheld83/ghactions_rhub"
LABEL "homepage"="http://github.com/maxheld83/ghactions_rhub"

LABEL "com.github.actions.name"="Build and Check R Packages"
LABEL "com.github.actions.description"="Build and Check R Packages with R-hub."
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
