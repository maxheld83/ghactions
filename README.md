# GitHub actions for R <img src="https://github.com/r-lib/ghactions/blob/master/logo.png?raw=true" align="right" height=140/>

[![Actions Status](https://wdp9fww0r9.execute-api.us-west-2.amazonaws.com/production/badge/r-lib/ghactions)](https://github.com/r-lib/ghactions/actions)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/ghactions)](https://cran.r-project.org/package=ghactions)
[![codecov](https://codecov.io/gh/maxheld83/ghactions/branch/master/graph/badge.svg)](https://codecov.io/gh/r-lib/ghactions)
[![License: MIT](https://img.shields.io/github/license/r-lib/ghactions.svg?style=flat)](https://opensource.org/licenses/MIT)

[GitHub actions](https://github.com/features/actions) are a new workflow automation feature of the popular code repository host GitHub.
The product is currently in **limited beta**.
It may offer a better way to adopt continuous integration and delivery best practices in the R community.
GitHub actions is a convenient service layer on top of the popular container standard docker, and is itself partly open source, thus limiting vendor lock-in.
Most importantly, **it is simple to reason about** if things go wrong.

The **ghactions** project offers three avenues to **bring GitHub actions to the `#rstats` community**:

<img src="https://github.com/r-lib/ghactions/blob/master/pkgwf.gif?raw=true" width=400/ align=right style="padding-left: 20px">

1. Some **actions** to run R-specific jobs on GitHub, including [arbitrary R code](https://r-lib.github.io/ghactions//articles/rscript-byod.html) or deploying to [shinyapps.io](http://shinyapps.io).
  These actions are maintained in this repository, but are not technically part of the accompanying ghactions R package.
  You can use these actions independently from the package; they are freely available on GitHub marketplace.
  In fact, the whole idea of GitHub actions is that people re-use such small building blocks any way they like.
2. The accompanying [**ghactions R package**](#workflows) furnishes you with some out-of-the-box **workflows** for different kinds of projects.
  These functions are styled after the popular [usethis](http://usethis.r-lib.org) package.
  They don't do much: They just set you up with some configuration files for your project, using sensible defaults.
3. Documenting experiences and evolving [**best practices**](https://r-lib.github.io/ghactions/articles/ghactions.html) for how to make the most of GitHub Actions for R.


## Installation

To install, run:

```r
remotes::install_github("r-lib/ghactions")
```

ghactions currently relies on a dev version of [usethis](http://usethis.r-lib.org), which should be automatically installed alongside it.

If you're using `devtools::install_github()` or otherwise currently have usethis loaded, you **may need to restart your the R session** before ghactions can find the dev usethis (RStudio > Session > Restart R).

Because you're likely only to ever use it *once*, **you need not take on ghactions as a dependency in your projects.**


## Quick Start

GitHub actions just requires a special file in a special directory at the root of your repository to work: `.github/main.workflow`.

To quickly set up such a file for frequently used project kinds, run:

```r
ghactions::use_ghactions(workflow = website())
```

See the documentation for implied defaults and alternatives.

Then push to GitHub and go to the actions tab in your repository.
Enjoy.
