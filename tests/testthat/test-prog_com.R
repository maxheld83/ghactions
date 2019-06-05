context("Programmatic changes")

test_that(desc = "can be detected", code = {
  no_change <- check_clean_tree(code = NULL)
  expect_true(object = no_change)
  some_changes <- check_clean_tree(code = {
    file.create("foo.bar")
  })
  expect_equal(
    object = some_changes,
    expected = c(
      # TODO would be nicer to test directly for foo, not the message, but that's what the output is
      "The following files were added or modified:\n- foo.bar"
    )
  )
})
