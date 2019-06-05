context("Test helpers")

describe(description = "dependency assertion", code = {
  it("errors out on non-existent package", {
    bad_pkgs <- "asdasdasdasdasd"
    expect_error(assert_deps(pkgs = bad_pkgs))
  })
})
