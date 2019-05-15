FROM repo:latest
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-lib/ghactions"
LABEL "homepage"="http://github.com/r-lib/ghactions"

LABEL "com.github.actions.name"="Build R Packages"
LABEL "com.github.actions.description"="Build Packages for rstats."
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

# below installation is baked into this image, but should not persist across actions
RUN Rscript -e "install.packages(c('pkgbuild'))"

# use persistent library
ENV R_LIBS_USER="/github/home/lib/R/library"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
