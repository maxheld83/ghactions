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
}

action "Test dependency installation" {
  uses = "maxheld83/ghactions_check@master"
  args = "testthat::test_dir(path = \"tests/testthat/\", stop_on_warning = FALSE)"
  needs = "Install Dependencies"
}
