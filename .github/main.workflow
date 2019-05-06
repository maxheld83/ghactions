workflow "Test" {
 on = "push"
 resolves = "test testthat"
}

action "test testthat" {
  uses = "./"
  args = "testthat::test_dir(path = \"tests/testthat/\")"
}
