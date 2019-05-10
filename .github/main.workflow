workflow "Test" {
 on = "push"
 resolves = "test testthat"
}

action "test testthat" {
  uses = "./"
  args = "Rscript -e \"testthat::test_dir(path = 'tests/testthat/', stop_on_failure = TRUE)\""
}
