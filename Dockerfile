FROM rhub/debian-gcc-release:latest

RUN apt-get install -y --no-install-recommends libssl-dev

# below installation is baked into this image, but should not persist across actions
RUN Rscript -e "install.packages(c('remotes', 'curl', 'git2r', 'pkgbuild'))"
# curl and git2r speed up pkg installation as per docs https://remotes.r-lib.org/index.html

COPY DESCRIPTION /github/workspace/DESCRIPTION
RUN Rscript -e "remotes::install_deps(pkgdir = '/github/workspace', dependencies = TRUE, verbose = TRUE)"
