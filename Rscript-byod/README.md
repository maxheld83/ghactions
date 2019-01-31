# Run `Rscript`, but *bring-your-own-dockerfile* (byod)

This is a very **simple** GitHub action; it just runs in Rscript whatever you provide as the `args` field (see below).
This action is meant for **generic** R projects with **arbitrary build environments**; you therefore **have to bring your own dockerfile**.
If you are targeting a specific build or runtime environment (say, `R CMD build` or [shinyapps.io](https://www.shinyapps.io)), some of the other actions may be more suitable for your purposes.
If you are *not* targeting a specific environment, and don't know much about docker, you can easily start with one of the popular rocker images as in the below example. 
Learn more about docker and R from the [rocker project](http://rocker-project.org).

A dockerfile is simply a text file called `Dockerfile` at the root of your repository.
At a minimum, it should include a `FROM` statement as in the below.
You are highly recommended to always use versioned images.

```
FROM rocker/verse:3.5.2
```

Because a dockerfile is just a *recipe* for a build environment, **you first have to build your `repo/Dockerfile`** into an image.
Happily, GitHub actions already provides an [action for that](https://github.com/actions/docker), which you should run as a first step in your `main.workflow` with minimal customization:

```
action "Build image" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  args = "build --tag=repo:latest ."
}
```

This just runs `docker build --tag=repo:latest .`, where `.` is the root of your repository.
Docker will then pick whichever `Dockerfile` it finds there, and well, *build* it.
Your dockerfile recipe has now been prepared into a meal, and this meal (the docker *image*) now exists in your `/github/workspace`.
This is a special directory that you won't ever see anywhere.
GitHub actions provisions this directory, and lets it *persist as long as your `main.workflow` runs*.

Any downstream actions (such as *this* action!) can now use the prepared image, but they have to know its name.
The `--tag=repo:latest` part of the above call simply names your image, literally "repo:latest".
This is just my convention, not a magic name.
But it is very important you *use exactly this name*, because otherwise downstream actions (*this* action) cannot base their own work on it.
This isn't terribly elegant, but currently appears to be the only way on GitHub actions to identify images from past actions (see [this issue](https://github.com/maxheld83/ghactions/issues/1)).

Once your "bring-your-own-dockerfile" has been build into an image, the present action then simply runs whatever you pass `Rscript` *in* that image.


## Environment Variables

None so far.


## Secrets

nada.


## Required Arguments

Whatever your provide in `args` simply gets appended to the `Rscript` call.
So just image `Rscript` in front of it; if it is a valid shell command, you're good to go.
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

Remember to be careful with quoting; you can use `'`, `"` and ``` but they must be nested correctly.


## Optional Arguments

Nope.


## Example Usage

Here is a complete `main.workflow` that first builds your (byod) image, and then runs `rmarkdown::render_site()` on it.

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
