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

describe(description = "system dependency assertion", code = {
  it("errors out on non-existent system dependency", {
    bad_sysdep <- "asdasdasdasdasdasd"
    expect_error(assert_sysdep(x = bad_sysdep))
  })
  it("succeds for existing system dependency", {
    good_sysdep <- "R"
    expect_equivalent(object = assert_sysdep(good_sysdep), expected = good_sysdep)
  })
})
