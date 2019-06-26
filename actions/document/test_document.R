context("document")
source_path <- "/ghactions-source/actions/document/"
test_that(desc = "good docs pass", code = {
  with_blp_repo(
    code = expect_list(hush(source(paste0(source_path, 'document.R')))),
    path = "good"
  )
})
test_that(desc = "bad docs fail", code = {
  with_blp_repo(
    code = expect_error(hush(source(paste0(source_path, 'document.R')))),
    path = "bad"
  )
})
