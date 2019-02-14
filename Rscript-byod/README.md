This is a very **simple** GitHub action; it just runs in `Rscript` whatever you provide as the `args` field (see below).
This action is meant for **generic** R projects with **arbitrary build environments**; you therefore [**have to bring your own dockerfile**](http://www.maxheld.de/ghactions/articles/ghactions.html#docker).
Such a `Dockerfile` has to exist at the root of your repository.

Whatever you pass `Rscript` will simply run *in* an image build from that `Dockerfile`.
Hence the name: **bring-your-own-dockerfile**.

You can find popular Docker images for R projects at the [Rocker Project](https://www.rocker-project.org/).

You can use the `ghactions::use_dockerfile()` function to set up a simple `Dockerfile` in your repository.

If you're using this action on your own, remember that **this action expects a built image called `repo:latest` in your `/github/workspace`.**
Use `ghactions::build_image()` to build such an image from your `Dockerfile` first.

If this all sounds rather complicated, consider the [short documentation](http://www.maxheld.de/ghactions/articles/ghactions.html#docker).


## Environment Variables

None so far.


## Secrets

nada.


## Required Arguments

Whatever your provide in `args` simply gets appended to the `Rscript` call.
So just imagine `Rscript` in front of it; if it is a valid shell command, you're good to go.
Remember that `Rscript` is the ([now preferred](https://stackoverflow.com/questions/18306362/run-r-script-from-command-line/18306656#18306656)) way to run R from a system shell (*not* the R console).
We have to use `Rscript`, because there's no GUI that could hook us up directly to the R console in our non-interactive image run.
[Here](https://stat.ethz.ch/R-manual/R-devel/library/utils/html/Rscript.html) is the full documentation.

A typical `args` example is

```bash
"-e 'rmarkdown::render_site()'"
```

which is appended to `Rscript` by this action, so you're really running

```bash
Rscript -e 'rmarkdown::render_site()'
```

which `Rscript` passes to the R console, where you know it as

```r
rmarkdown::render_site()
```


## Optional Arguments

Nope.


## Example Usage

Here is a complete `main.workflow` that first builds your (byod) image, and then runs `rmarkdown::render_site()` on it.
You can also get this automatically by running one of the `ghactions::website()` function in the ghactions package.

```
workflow "Build then render" {
  on = "push"
  resolves = "Render rmarkdown"
}

action "Build image" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  args = "build --tag=repo:latest ."
}

action "Render rmarkdown" {
  needs = "Build image"
  uses = "maxheld83/ghactions/Rscript-byod@master"
  args = "-e 'rmarkdown::render_site()'"
}
```

Of course, you can also use the visual workflow editor in GitHub, which is highly recommended.

The cryptic-seeming `uses = "maxheld83/ghactions/Rscript-byod@master"` in the above is simply a way to take a *particular* version of this action as a dependency.
The part after `@` is a git tag, or release from my (= the action developer's) repo.
It is generally recommended to specify dependencies in GitHub actions as narrowly as you can.
That way, your workflow won't break if the maintainer of the action changes things up.
