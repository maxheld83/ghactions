context("Automatic commits")
library(checkmate)

test_that(desc = "Clean tree after `code` passes", code = {
  with_blank_repo(code = {
    expect_true(object = check_clean_tree())
  })
  with_blank_repo(code = {
    expect_null(object = auto_commit())
  })
})
test_that(desc = "Dirty tree after `code` errors", code = {
  with_blank_repo(code = {
    expect_equal(
      object = check_clean_tree(code = fs::file_create("foo.bar")),
      # TODO would be nicer to test directly for foo, not the message, but that's what the output is
      expected = "The following files were added or modified:\n?? foo.bar"
    )
  })
  with_blank_repo(code = {
    expect_error(auto_commit(code = fs::file_create("foo.bar")))
  })
})
test_that(desc = "Dirty tree after `code` gets committed", code = {
  with_blank_repo(code = {
    # should return feedback from git commands
    expect_list(
      x = {
        auto_commit(
          code = fs::file_create("foo.bar"),
          after_code = "commit"
        )
      }
    )
    # should be clean now
    expect_true(
      object = check_clean_tree()
    )
    # should still exist
    expect_file_exists(
      x = "foo.bar"
    )
  })
})

test_that(desc = "Dirty tree before `code` errors", code = {
  with_blank_repo(code = {
    fs::file_create("dirt.txt")
    expect_error(object = check_clean_tree(before_code = "stop"))
  })
})
test_that(desc = "Dirty tree before `code` is stashed/poppped", code = {
  with_blank_repo(code = {
    fs::file_create("dirt.txt")
    expect_true(object = check_clean_tree(before_code = "stash"))
    # file should be back after `git stash pop`
    checkmate::expect_file_exists("dirt.txt")
  })
})
test_that(desc = "Dirty tree before `code` is committed", code = {
  with_blank_repo(code = {
    fs::file_create("dirt.txt")
    expect_true(check_clean_tree(before_code = "commit"))
    # file should be back after `git reset HEAD^1`
    checkmate::expect_file_exists("dirt.txt")
  })
})
