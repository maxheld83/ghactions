# GitHub Actions for R <img src="https://github.com/maxheld83/ghactions/blob/master/logo.png?raw=true" align="right" height=140/>

<!-- badges: start -->
[![Actions Status](https://github.com/maxheld83/ghactions/workflows/.github/workflows/main.yml/badge.svg)](https://github.com/maxheld83/ghactions/actions)
[![codecov](https://codecov.io/gh/maxheld83/ghactions/branch/master/graph/badge.svg)](https://codecov.io/gh/maxheld83/ghactions)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/ghactions)](https://cran.r-project.org/package=ghactions)
[![License: MIT](https://img.shields.io/github/license/r-lib/ghactions.svg?style=flat)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

[GitHub Actions](https://github.com/features/actions) are a new workflow automation feature of the popular code repository host GitHub.

This package helps R users get started quickly with GitHub Actions:

1. It provides **workflow** templates for common R projects (packages, RMarkdown, ...) with sensible defaults.
2. It wraps and curates relevant existing **external actions**, such as those to deploy to GitHub Pages or Netlify.
3. It exposes the GitHub Actions workflow **syntax** and lets you write GitHub Actions `*.yml`s from R. 
  (Which isn't saying that *should* be doing that.)

## Installation

To install, run:

```r
remotes::install_github("maxheld83/ghactions")
```

Because you're likely only to ever use it *once*, **you need not take on ghactions as a dependency in your projects.**

## Quick Start

GitHub actions just requires a special file in a special directory at the root of your repository to work: `.github/workflows/main.yml`.

To quickly set up such a file for frequently used project kinds, run:

```r
ghactions::use_ghactions(workflow = ghactions::website())
```

See the documentation for implied defaults and alternatives.

Then push to GitHub and go to the actions tab in your repository.
