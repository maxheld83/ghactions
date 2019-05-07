# GitHub Action to Install Package Dependencies

This action lets you install R packages (and their R dependencies) into your workflow's working directory (`/github/workspace`).
By installing libraries into this persistent directory, later actions can use these dependencies.

Notice that this action installs *R packages* with *R package dependencies*, not ~~system dependencies~~.


## Secrets

None.


## Environment Variables

None.


## Arguments

None.


## Example Usage

```
action "Install R Dependencies" {
  uses = "maxheld83/ghactions-inst-rdep@master"
}
```
