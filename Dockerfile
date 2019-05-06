FROM rhub/debian-gcc-release
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/maxheld83/ghactions_testthat"
LABEL "homepage"="http://github.com/maxheld83/ghactions_testthat"

LABEL "com.github.actions.name"="Run Testthat Tests"
LABEL "com.github.actions.description"="Unit test in R using testthat."
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="blue"

RUN Rscript -e "install.packages('testthat')"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
