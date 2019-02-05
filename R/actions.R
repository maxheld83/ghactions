#' @title Docker CLI
#'
#' @template actions
#'
#' @description
#' Minimal wrapper around the (external) [Docker CLI](https://github.com/actions/docker/tree/master/cli) action.
#' Below details are reproduced from the original Docker repository.
docker_cli <- function(uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6",
                       args = "build --tag=repo:latest .") {
  list(uses = uses, args = args)
}

#' @title Rscript-byod
#'
#' @description
#' Run arbitrary `Rscript`, but *bring-your-own-dockerfile*
#' Minimal wrapper around the (internal) [Rscript-byod](https://github.com/maxheld83/ghactions/tree/master/Rscript-byod) action.
#'
#' @template actions
#'
#' @eval readme2sections()
#'
#' @export
rscript_byod <- function(uses = "maxheld83/ghactions/Rscript-byod@master",
                         needs = "Build image",
                         args) {
  list(uses = uses, needs = needs, args = args)
}

#' @title Filter
#'
#' @template actions
filter <- function(uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd",
                   needs = "Render",
                   args = "branch master") {
  list(uses = uses, needs = needs, args = args)
}

#' @title Rsync
#'
#' @template actions
rsync <- function(uses = "maxheld83/rsync@v0.1.1",
                  needs = "Master",
                  secrets = c("SSH_PRIVATE_KEY", "SSH_PUBLIC_KEY"),
                  env,
                  args) {
  list(uses = uses, needs = needs, secrets = secrets, env = env, args = args)
}
