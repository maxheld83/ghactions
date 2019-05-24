## Install Package Dependencies

This GitHub action installs R package dependencies from a `DESCRIPTION` at your project root.

Notice that this action installs *R packages* with *R package dependencies*, not ~~system dependencies~~.


### Secrets

None.


### Environment Variables

- [**`R_LIBS`**](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), a vector of paths prepended to existing `.libPaths()`.
    
    Defaults to `R_LIBS_WORKFLOW` (`[$HOME](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#filesystem)/lib/R/library`) where they persist over the run of the workflow.
    All earlier or later actions that have `R_LIBS_WORKFLOW` in their `.libPaths()` can install to or load from this path.
    
    For more details, read the vignette on action [isolation](/articles/isolation/).


### Arguments

None.


### Example Usage

#### Simple (Recommended)

```
action "Install Dependencies" {
  uses = "r-lib/ghactions/actions/install-deps@master"
}
```

#### Advanced Usage (Not Recommended)

To keep installed packages only for this action, set:

```
action "Custom Installation" {
  uses = "r-lib/ghactions/actions/install-deps@master"
  env = {
    R_LIBS = "$R_LIBS_ACTION"
  }
}
```

### Caveats

#### No Caching

GitHub actions currently has no native caching support.
For more information, read the vignette on [performance](/articles/performance/).
