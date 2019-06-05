context("Test helpers")

describe(description = "dependency assertion", code = {
  it("errors out on non-existent package", {
    bad_pkgs <- "asdasdasdasdasd"
    expect_error(assert_deps(pkgs = bad_pkgs))
  })
  it("succeeds on existing package", {
    good_pkgs <- "testthat"
    expect_equivalent(object = assert_deps(good_pkgs), expected = good_pkgs)
  })
  it("succeeds for several", {
    good_pkgs <- c("testthat", "ghactions", "withr")
    expect_equivalent(object = assert_deps(good_pkgs), expected = good_pkgs)
  })
})
