# GitHub Action to Install R Package Dependencies

This action lets you install R packages (and their R dependencies) into your workflow's home directory (`/github/home`, a.k.a. `$HOME`).
By installing libraries into this persistent directory, later actions can use these dependencies.

So as not to interfere with your repository payload or build artifacts, packages are *not* installed into ~~`/github/workspace` a.k.a. `$GITHUB_WORKSPACE`~~.
Though [not explicitly](https://github.com/maxheld83/ghactions-inst-rdep/issues/10) mentioned in the [github actions documentation](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#filesystem), `/github/workspace` also [appears to persist](https://github.com/maxheld83/persistent-home).

Notice that this action installs *R packages* with *R package dependencies*, not ~~system dependencies~~.


## Secrets

None.


## Environment Variables

None.


## Arguments

None.


## Example Usage

```
action "Install Dependencies" {
  uses = "maxheld83/ghactions-install-deps@master"
}
```
