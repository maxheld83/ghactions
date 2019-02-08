# GitHub actions for R <img src="https://github.com/maxheld83/ghactions/blob/master/logo.png?raw=true" align="right" height=140/>

[![Actions Status](https://wdp9fww0r9.execute-api.us-west-2.amazonaws.com/production/badge/maxheld83/ghactions)](https://github.com/maxheld83/ghactions/actions)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/ghactions)](https://cran.r-project.org/package=ghactions)
[![codecov](https://codecov.io/gh/maxheld83/ghactions/branch/master/graph/badge.svg)](https://codecov.io/gh/maxheld83/ghactions)
[![License: MIT](https://img.shields.io/github/license/maxheld83/ghactions.svg?style=flat)](https://opensource.org/licenses/MIT)

[GitHub actions](https://github.com/features/actions) are a new workflow automation feature of the popular code repository host GitHub.
The product is currently in **limited beta**.

This repository, **ghactions**, offers three avenues to **bring GitHub actions to the `#rstats` community**:

1. Some [**actions**](#actions) to run R-specific jobs on GitHub, including [arbitrary R code](http://www.maxheld.de/ghactions/articles/rscript-byod.html) or deploying to [shinyapps.io](http://shinyapps.io).
  These actions are maintained in this repository, but are not technically part of the accompanying ghactions R package.
  You can use these actions independently from the package; they are freely available on GitHub marketplace.
  In fact, the whole idea of GitHub actions is that people re-use such small building blocks any way they like.
2. The accompanying [**ghactions R package**](#workflows) furnishes you with some out-of-the-box **workflows** for many kinds of projects.
  These functions are styled after the popular [usethis](http://usethis.r-lib.org) package.
  They don't do much: They just set you up with some configuration files for your project, using sensible defaults.
3. Documenting experiences and evolving [**best practices**](http://www.maxheld.de/ghactions/articles/why) for how to make the most of GitHub actions for R.


## Getting Started

If you haven't gotten access yet, [sign up](https://github.com/features/actions) for the closed beta of GitHub actions.

To install, run:

```r
devtools::install_github("maxheld83/ghactions")
```


## Actions

The below workflow function(s) paste together individual actions.
There are also separate functions to generate these individual actions, which again, are simple paste jobs.

They only exist as R functions to simplify the documentation in *one* place and to reuse them elegantly across several actions.


```
# just pseudocode, does not exist yet
ghaction::Rsync_byod(
  title = "Render rmarkdown", 
  needs = "Build image", 
  uses = "maxheld83/ghactions/Rscript-byod@master"
  args = "-e 'rmarkdown::render_site()'"
)
```


## Workflows

This function generates `main.workflow` files for common workflow configurations of R projects.

Typical invocations may include:

```r
# this is just pseudcode; functions don't exist yet
ghaction::use_ghaction(type = "rmarkdown", deploy_target = "rsync")
ghaction::use_ghaction(type = "package", covr = TRUE, pkgdown = TRUE, deploy_target = "ghpages")
```


## Docker



## Why You Should Care


## Thanks

ghactions doesn't really do much work, let alone hard work.
It leaves that to other open source software and their generous authors.

First and foremost, GitHub Actions is build on top of Docker, and so, by extension, is this package.
It would not work without the tremendous work of [Carl Boettiger](https://www.carlboettiger.info) and [Dirk Edelbuettel](http://dirk.eddelbuettel.com), who carefully maintain versioned Docker images for R through their [Rocker Project](http://rocker-project.org).

This package is also heavily modeled on, and indebted to the [usethis](https://usethis.r-lib.org) package by [Jenny Bryan](https://jennybryan.org) and [Hadley Wickham](http://hadley.nz).


## Related and Prior Work

There are plenty of other proven ways to run CI/CD for R.
Many rely on the [R support on TravisCI](https://docs.travis-ci.com/user/languages/r/), maintained by [Jeron Ooms](https://github.com/jeroen) and [Jim Hester](https://www.jimhester.com).
The [travis](https://ropenscilabs.github.io/travis/) and [tic](https://ropenscilabs.github.io/tic/) packages make it easier to work with them.
You can use [AppVeyor](http://appveyor.com)'s Windows-based system via the [r-appveyor](https://github.com/krlmlr/r-appveyor) package.

For serious, cross-platform testing of packages, there's the [r-hub](http://r-hub.io) project.

There are also other and additional ways to use R and Docker together.
The recommended way to use Dockere here is to simply edit a `DOCKERFILE` by hand, but the [containerit](http://o2r.info/containerit/) package can also, miraculously, do this for you by parsing your project files.
We are here primarily concerned with running R *inside Docker* (inside GitHub actions), but there are also some packages that allow you to control Docker from *inside R*, including [stevedore](https://richfitz.github.io/stevedore/), [harbor](https://github.com/wch/harbor) and [docker](https://bhaskarvk.github.io/docker/)., though it facilitates running Docker *inside R*, whereas GitHub Actions runs R *inside Docker*.
The broader topic of reproducibility in R with the help of Docker is also adressed by the [rrtools](https://github.com/benmarwick/rrtools) and [liftr](https://liftr.me) packages, as well as the [o2r](https://o2r.info) and [ropensci](https://ropensci.org) projects.
