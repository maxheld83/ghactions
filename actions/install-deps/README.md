# GitHub Action to Install R Package Dependencies

This action lets you install R packages (and their R dependencies) by running `remotes::install_deps()`.

By default, it installs packages into a subdirectory in your workflow's home directory (`/github/home`, a.k.a. [`$HOME`](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#filesystem)).
By installing libraries into this persistent directory, later actions can use these dependencies, if passed the appropriate `R_LIBS_USER` environment variable (see below.)

Notice that this action installs *R packages* with *R package dependencies*, not ~~system dependencies~~.


## Secrets

None.


## Environment Variables

- [**`R_LIBS_USER`**](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), the path to the R user library of packages.
    
    Defaults to `/github/home/lib/R/library`, a directory that persists across actions in the same run and workflow.
    Gets prepended to the library trees of [`.libPaths()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), so that this path becomes the first place where R will look for a package.
    
    To let later actions in the same run and workflow use these packages, set the same `R_LIBS_USER` environment variable in those downstream actions.


## Arguments

- ... arbitrary shell commands, defaults to `remotes::install_deps(dependencies = TRUE)`.


## Example Usage

### Simple (Recommended)

```
action "Install Dependencies" {
  uses = "r-lib/ghactions/actions/install-deps@master"
}
```

### Advanced Usage (Not Recommended)

```
action "Custom Installation" {
  uses = "r-lib/ghactions/actions/install-deps@master"
  env = {
    R_LIBS_USER = ""
  }
  args = [
    "Rscript -e \"1+1\"",
    "Rscript -e \"2+2\""
  ]
}
```

- Set `R_LIBS_USER` to an empty string for standard R behavior.
- Setting any `args` will overwrite the default.
    To pass a file to `Rscript` provide it with a relative path from the repository root.
    
    **Warning**: When you provide custom commands, you loose the checks usually run by this package. 
    You're on your own.


## Caveats

### No Caching

GitHub actions currently has no native caching support.
While the `R_LIBS_USER` directory of installed packages persists across actions, all dependencies have to be reinstalled for every workflow or run.
This can take some time.
For more information, see [this issue]()


### Reliance on Semi-Documented Behavior for `$HOME`

The [GitHub actions documentation](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#filesystem) only explicitly lists directory to persist across actions: `/github/workspace` (`$GITHUB_WORKSPACE`).
However, that directory is not ideal to store the R user package library, because the repository content and build artifacts are created in the same place, potentially causing conflicts.
`R_LIBS_USER` is therefore set to `/github/home` (`$HOME`), which also [appears to persist](https://github.com/maxheld83/persistent-home).
