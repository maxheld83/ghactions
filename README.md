# GitHub actions for R <img src="https://github.com/maxheld83/ghactions/blob/master/logo.png?raw=true" align="right" height=140/>

[![Actions Status](https://wdp9fww0r9.execute-api.us-west-2.amazonaws.com/production/badge/maxheld83/ghactions)](https://github.com/maxheld83/ghactions/actions)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/ghactions)](https://cran.r-project.org/package=ghactions)
[![codecov](https://codecov.io/gh/maxheld83/ghactions/branch/master/graph/badge.svg)](https://codecov.io/gh/maxheld83/ghactions)
[![License: MIT](https://img.shields.io/github/license/maxheld83/ghactions.svg?style=flat)](https://opensource.org/licenses/MIT)

[GitHub actions](https://github.com/features/actions) are a new workflow automation feature of the popular code repository host GitHub.
The product is currently in **limited beta**.

Here are a few reasons why GitHub actions is worth a try, especially R projects.

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
