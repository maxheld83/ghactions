library(testthat)
library(ghactions)

if (requireNamespace("xml2")) {
  test_check("ghactions", reporter = MultiReporter$new(reporters = list(JunitReporter$new(file = "test-results.xml"), CheckReporter$new())))
} else {
  test_check("ghactions")
}
