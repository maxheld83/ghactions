FROM rocker/verse:3.5.2

RUN install2.r checkmate gh
RUN installGithub.r r-lib/usethis#629
