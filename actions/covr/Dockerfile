FROM rhub/debian-gcc-release
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-hub/ghactions"
LABEL "homepage"="http://github.com/r-hub/ghactions"

LABEL "com.github.actions.name"="Measure Test Coverage"
LABEL "com.github.actions.description"="Measure test coverage using covr."
LABEL "com.github.actions.icon"="pie-chart"
LABEL "com.github.actions.color"="blue"

# required for covr
RUN apt-get install -y --no-install-recommends libssl-dev

# below installation is baked into this image, but should not persist across actions
RUN Rscript -e "install.packages(c('covr'))"
# TODO these are just hotpatches until https://github.com/r-lib/ghactions/issues/207
RUN Rscript -e "install.packages(c('desc'))"
RUN Rscript -e "install.packages(c('cli'))"

# use persistent library
ENV R_LIBS_USER="/github/home/lib/R/library"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
