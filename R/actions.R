actions <- NULL

#' @title Wrappers for GitHub Actions
#'
#' @description
#' Minimal wrappers.
#'
#' @inheritParams make_action_block
#'
#' @name actions
#'
#' @family actions
#'
#' @export
NULL

#' @title Build image
#'
#' @inheritParams make_action_block
#'
#' @family actions
#'
#' @export
actions$build_image <- function(uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6",
                                args = "build --tag=repo:latest .") {
  # TODO surely this can be simplified
  list(uses = uses, args = args)
}

#' @describeIn actions Rscript-byod
#' @export
actions$rscript_byod <- function(uses = "maxheld83/ghactions/Rscript-byod@master",
                                 needs = "Build image",
                                 args) {
  list(uses = uses, needs = needs, args = args)
}

#' @describeIn actions Filter
#' @export
actions$filter <- function(uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd",
                           needs = "Render",
                           args = "branch master") {
  list(uses = uses, needs = needs, args = args)
}

#' @describeIn actions Rsync
#' @export
actions$rsync <- function(uses = "maxheld83/rsync@v0.1.1",
                          needs = "Master",
                          secrets = c("SSH_PRIVATE_KEY", "SSH_PUBLIC_KEY"),
                          env,
                          args) {
  list(uses = uses, needs = needs, secrets = secrets, env = env, args = args)
}
