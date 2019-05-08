# GitHub Action to Install R Package Dependencies

This action lets you install R packages (and their R dependencies) by running `remotes::install_deps()`.

By default, it installs packages into a subdirectory in your workflow's home directory (`/github/home`, a.k.a. [`$HOME`](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#filesystem)).
By installing libraries into this persistent directory, later actions can use these dependencies, if passed the appropriate `R_LIBS_USER` environment variable (see below.)

Notice that this action installs *R packages* with *R package dependencies*, not ~~system dependencies~~.


## Secrets

None.


## Environment Variables

- [**`R_LIBS_USER`**](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), the path for the R user library of packages.
    
    Defaults to `/github/home/lib/R/library`, a directory that persists across actions in the same run and workflow.
    Gets prepended to the library trees of [`.libPaths()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), so that this path becomes the first place where R will look for a package.
    
    To let later actions in the same run and workflow use these packages, set the same `R_LIBS_USER` environment variable in those downstream actions.


## Arguments

None.


## Example Usage

```
action "Install Dependencies" {
  uses = "maxheld83/ghactions-install-deps@master"
}
```

Set `R_LIBS_USER` to an empty string for standard R behavior (not recommended).

```
action "Install Dependencies" {
  uses = "./"
  env = {
    R_LIBS_USER = ""
  }
}
```


## Caveat 

So as not to interfere with your repository payload or build artifacts, packages are *not* installed into ~~`/github/workspace` a.k.a. `$GITHUB_WORKSPACE`~~.
Though [not explicitly](https://github.com/maxheld83/ghactions-inst-rdep/issues/10) mentioned in the [github actions documentation](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#filesystem), `/github/workspace` also [appears to persist](https://github.com/maxheld83/persistent-home).
