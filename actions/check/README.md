This action tests an R package.


## Secrets

None.


## Environment Variables

- [**`R_LIBS_USER`**](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), the path to the R user library of packages.

    Defaults to `/github/home/lib/R/library`, where the [ghactions-install](https://github.com/maxheld83/ghactions-install-deps) action installs dependencies.
    <!-- todo add link -->
    See the `install-docs` action for more details.


## Arguments

- ... arbitrary shell commands, defaults to `rcmdcheck::rcmdcheck(error_on = 'warning')`.
    See below for an example.


## Example Usage


### Simple (Recommended)

```
action "Check Package" {
  uses = "r-lib/ghactions/actions/check@master"
}
```


### Advanced Usage (Not Recommended)

Because this action ships with [*testthat*](https://testthat.r-lib.org), you can also use it to run arbitrary tests.

```
action "Custom Tests" {
  uses = "r-lib/ghactions/actions/check@master"
  args = [
    "Rscript -e "testthat::test_that(desc = 'test', code = expect_equal(1, 1))"
  ]
}
```
