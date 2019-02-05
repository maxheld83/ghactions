# documentation ====

#' @title Create roxygen sections from GitHub Action Readmes
#'
#' @param path `[character(1)]`
#' Giving path from repo root.
readme2sections <- function(path = "Rscript-byod/README.md") {
  res <- readr::read_lines(path)
  glue::glue(
    "@details \n",
    glue::glue_collapse(x = res, sep = "\n")
  )
}
