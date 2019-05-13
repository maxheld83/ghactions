# GitHub Actions to Check Packages (and Run Other Tests)

This action runs `R CMD check` on a package in your repository root.


## Secrets

None.


## Environment Variables

- [**`R_LIBS_USER`**](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), the path to the R user library of packages.

    Defaults to `/github/home/lib/R/library`, where the [ghactions-install](https://github.com/maxheld83/ghactions-install-deps) action installs dependencies.
    See [docs](https://github.com/maxheld83/ghactions-install-deps) for more details.


## Arguments

- ... arbitrary shell commands, defaults to `R CMD check`.
    See below for an example.


## Example Usage


### Simple (Recommended)

```
action "Install Dependencies" {
  uses = "maxheld83/ghactions-check@master"
}
```


### Advanced Usage (Not Recommended)

```
action "Custom Tests" {
  uses = "uses = "maxheld83/ghactions-check@master"
  args = [
    "Rscript -e "testthat::test_that(desc = 'test', code = expect_equal(1, 1))"
  ]
}
```
