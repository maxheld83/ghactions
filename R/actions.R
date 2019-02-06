#' @title R wrappers around GitHub actions
#'
#' @description
#' These functions are for **advanced users** knowledgeable about GitHub actions.
#' Novice users may be better served by the complete templates in workflows.
#'
#' These functions provide very thin wrappers around existing GitHub actions, including actions from other repositories.
#' For documentation on these actions, consult their respective `README.md`s linked in the below.
#' Some of these action wrappers include sensible defaults for most uses in R.
#' You can always create action blocks entirely from scratch using [make_action_block()].
#'
#' The `uses` field is always hardcoded to a particular commit or tag of the underlying github action to ensure.
#'
#' @inheritParams make_action_block
#'
#' @name actions
NULL

#' @describeIn actions [Docker CLI](https://github.com/actions/docker/tree/aea64bb1b97c42fa69b90523667fef56b90d7cff)
docker_cli <- function(args = "build --tag=repo:latest .") {
  list(
    uses = "actions/docker/cli@aea64bb1b97c42fa69b90523667fef56b90d7cff",
    args = args
  )
}

#' @describeIn actions [Rscript-byod](https://github.com/maxheld83/ghactions/tree/master/Rscript-byod)
rscript_byod <- function(needs,
                         args) {
  list(
    uses = "maxheld83/ghactions/Rscript-byod@master",
    # this actually does *not* need a harder dependency, because it is versioned in this repo
    needs = needs,
    args = args)
}

#' @describeIn actions [filter](https://github.com/actions/bin/tree/a9036ccda9df39c6ca7e1057bc4ef93709adca5f/filter)
filter <- function(needs,
                   args = "branch master") {
  list(
    uses = "actions/bin/filter@a9036ccda9df39c6ca7e1057bc4ef93709adca5f",
    needs = needs,
    args = args
  )
}

#' @describeIn actions [rsync](https://github.com/maxheld83/rsync/tree/v0.1.1)
rsync <- function(needs,
                  env,
                  args) {
  list(
    uses = "maxheld83/rsync@v0.1.1",
    needs = needs,
    secrets = c("SSH_PRIVATE_KEY", "SSH_PUBLIC_KEY"),
    env = env,
    args = args
  )
}

#' @describeIn actions [ghpages](https://github.com/maxheld83/ghpages/tree/v0.1.2)
ghpages <- function(needs,
                    env = "BUILD_DIR = 'public/'") {
  list(
    uses = "maxheld83/ghpages@v0.1.2",
    needs = needs,
    secrets = "GH_PAT",
    env = env
  )
}
