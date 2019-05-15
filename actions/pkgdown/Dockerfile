FROM rhub/debian-gcc-release
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/r-hub/ghactions"
LABEL "homepage"="http://github.com/r-hub/ghactions"

LABEL "com.github.actions.name"="Create Documentation Website"
LABEL "com.github.actions.description"="Create website for rstats packages with pkgdown."
LABEL "com.github.actions.icon"="book-open"
LABEL "com.github.actions.color"="blue"

RUN apt-get install -y --no-install-recommends libxml2-dev
RUN apt-get install -y --no-install-recommends libssl-dev

# bake pkg into image, but do not let it persist across actions
RUN Rscript -e "install.packages('pkgdown')"

# use persistent library
ENV R_LIBS_USER="/github/home/lib/R/library"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
