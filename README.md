# GitHub actions for R <img src="https://github.com/maxheld83/ghactions/blob/master/logo.png?raw=true" align="right" height=140/>

[![Actions Status](https://wdp9fww0r9.execute-api.us-west-2.amazonaws.com/production/badge/maxheld83/ghactions)](https://github.com/maxheld83/ghactions/actions)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/ghactions)](https://cran.r-project.org/package=ghactions)
[![codecov](https://codecov.io/gh/maxheld83/ghactions/branch/master/graph/badge.svg)](https://codecov.io/gh/maxheld83/ghactions)
[![License: MIT](https://img.shields.io/github/license/maxheld83/ghactions.svg?style=flat)](https://opensource.org/licenses/MIT)


`ghactions` is closely modelled on the popular `usesthis` package: you can use it to paste configuration files with sensible defaults to get you started.

There are two kinds of function in this package: those who paste the code for individual actions, and those who paste the code for entire workflows.

## Workflows

This function generates `main.workflow` files for common workflow configurations of R projects.

Typical invocations may include:

```
# this is just pseudcode; functions don't exist yet
ghaction::use_ghaction(type = "rmarkdown", deploy_target = "rsync")
ghaction::use_ghaction(type = "package", covr = TRUE, pkgdown = TRUE, deploy_target = "ghpages")
```


## Actions

The above workflow function(s) paste together individual actions.
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
