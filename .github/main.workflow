workflow "Test Action" {
  on = "push",
  resolves = ["Shellcheck", "Test dependency installation"]
}

action "Shellcheck" {
  uses = "actions/bin/shellcheck@1b3c130914f7b20890bf159306137d994a4c39d0"
  args = "*.sh"
}

action "Install Dependencies" {
  uses = "./"
  # custom arg is for test only
  args = [
    "Rscript -e \"remotes::install_deps(pkgdir = 'tests/testthat/descriptions/good')\""
  ]
}

action "Test dependency installation" {
  uses = "maxheld83/ghactions_check@19e9741dc6d08851fc8b621baf32c5362d463fc3"
  args = "testthat::test_dir(path = \"tests/testthat/\", stop_on_failure = TRUE)"
  needs = "Install Dependencies"
}
