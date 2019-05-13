FROM rhub/debian-gcc-release
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/maxheld83/ghactions-check"
LABEL "homepage"="http://github.com/maxheld83/ghactions-check"

LABEL "com.github.actions.name"="Run Checks"
LABEL "com.github.actions.description"="Run R CMD check for rstats."
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="blue"

# bake testthat into image, but do not let it persist across actions
RUN Rscript -e "install.packages('testthat')"

# now we set the user library to a persistent folder, so that R inside the container can find the dependencies installed in earlier actions
ENV R_LIBS_USER="/github/home/lib/R/library"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
