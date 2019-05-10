FROM rhub/debian-gcc-release
# github actions recommends debian, and this is the one closest to cran https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/

LABEL "maintainer"="Maximilian Held <info@maxheld.de>"
LABEL "repository"="http://github.com/maxheld83/ghactions-install-deps"
LABEL "homepage"="http://github.com/maxheld83/ghactions-install-deps"

LABEL "com.github.actions.name"="Install R Package Dependencies"
LABEL "com.github.actions.description"="Install Package Dependencies for Rstats."
LABEL "com.github.actions.icon"="arrow-down-circle"
LABEL "com.github.actions.color"="blue"

# below installation is baked into this image, but should not persist across actions
RUN Rscript -e "install.packages(c('remotes', 'curl', 'git2r', 'pkgbuild'))"
# curl and git2r speed up pkg installation as per docs https://remotes.r-lib.org/index.html

# now we set the user library to a persistent folder, so that any installations *inside* the container will persist across actions
ENV R_LIBS_USER="/github/home/lib/R/library"

COPY install.R /install.R
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
