FROM rocker/verse:3.5.2

RUN install2.r checkmate gh
RUN installGithub.r r-lib/usethis@fbb03d11a06fc46ee3dafc806b4b9298fb89a9ca
