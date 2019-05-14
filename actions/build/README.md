## Build a Package

This GitHub action builds a R Package.

By default, it builds the package into your workspace (`/github/workspace`, or `$GITHUB_WORKSPACE`, where the archive will persist for later actions in the same workflow.

### Secrets

None.


### Environment Variables

- [**`R_LIBS_USER`**](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html), the path to the R user library of packages.
    
    Defaults to `/github/home/lib/R/library`, a directory that persists across actions in the same run and workflow.
    <!-- TODO add link to install-deps actions -->
    See the `install_deps` actions for details.


### Arguments

- ... arbitrary shell commands, defaults to `pkgbuild::build(path = '/.')`.


### Example Usage

action "Build Package" {
  uses = "r-lib/ghactions/actions/build@master"
}
