context("Test helpers")

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
