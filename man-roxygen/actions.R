#' @description
#' Thin wrapper around GitHub actions.
#'
#' @details
#' These functions are for **advanced users** knowledgeable about GitHub actions.
#' Novice users may be better served by the complete templates in workflows.
#'
#' These functions provide very thin wrappers around existing GitHub actions, including actions from other repositories.
#' Essentially, they just create lists ready to be ingested by [action2hcl()], which then turns these R lists into valid GitHub actions syntax blocks.
#'
#' For documentation on these actions, consult their respective `README.md`s linked in the below.
#' Some variants of these action wrappers include sensible defaults for frequent uses in R.
#'
#' The `uses` field is *always* hardcoded to a particular commit or tag of the underlying github action to ensure compatibility.
#'
#' To render an action block completely from scratch, you can always use the templating function [action()].
#'
#' @inheritParams action
#'
#' @param ...
#' arguments passed on to other methods, not currently used.
#'
#' @family actions
