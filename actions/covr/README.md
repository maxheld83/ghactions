## Measure Code Coverage

This GitHub action measures test coverage and uploads results to [codecov](https://codecov.io/) using [*covr*](https://covr.r-lib.org).


### Secrets

- [`CODECOV_TOKEN`](https://codecov.io/site/security) to authenticate against codecov.


### Environment Variables

- [**`R_LIBS`**](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), a vector of paths prepended to existing `.libPaths()`.
    
    Defaults to `R_LIBS_WORKFLOW` (`[$HOME](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#filesystem)/lib/R/library`) where they persist over the run of the workflow.
    All earlier or later actions that have `R_LIBS_WORKFLOW` in their `.libPaths()` can install to or load from this path.
    
    For more details, read the vignette on action [isolation](/articles/isolation/).


### Arguments

None.


### Example Usage

```
action "Install Package" {
  uses = "r-lib/ghactions/actions/install@master"
}
```
