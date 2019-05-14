## Render Package Website With *pkgdown*

This GitHub action renders a documentation website using for R packages using [pkgdown](https://pkgdown.r-lib.org/).


### Secrets

None.


### Environment Variables

- [**`R_LIBS_USER`**](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), the path to the R user library of packages.

    Defaults to `/github/home/lib/R/library`, where the [ghactions-install](https://github.com/maxheld83/ghactions-install-deps) action installs dependencies.
    <!-- todo add link -->
    See the `install-docs` action for more details.


### Arguments

- ... arbitrary shell commands, defaults to `rcmdcheck::rcmdcheck(error_on = 'warning')`.
    See below for an example.


### Example Usage

```
action "Check Package" {
  uses = "r-lib/ghactions/actions/pkgdown@master"
}
```
