FROM rhub/debian-gcc-release
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-hub/ghactions"
LABEL "homepage"="http://github.com/r-hub/ghactions"

LABEL "com.github.actions.name"="Install R Package"
LABEL "com.github.actions.description"="Install R package."
LABEL "com.github.actions.icon"="play-circle"
LABEL "com.github.actions.color"="blue"

# required for devtools
RUN apt-get install -y --no-install-recommends libssl-dev

# below installation is baked into this image, but should not persist across actions
RUN Rscript -e "install.packages(c('devtools'))"

# use persistent library
ENV R_LIBS_USER="/github/home/lib/R/library"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
