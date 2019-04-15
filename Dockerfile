FROM rocker/verse:3.5.3

RUN install2.r checkmate gh
RUN installGithub.r r-lib/usethis@fe246d94eafb3228523d6e7486720a79115654fa
