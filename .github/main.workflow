workflow "Test Action" {
  on = "push",
  resolves = ["Install Dependencies"]
}

action "Shellcheck" {
  uses = "actions/bin/shellcheck@1b3c130914f7b20890bf159306137d994a4c39d0"
  args = "*.sh"
}

action "Install Dependencies" {
  uses = "./"
}

action "Test dependency installation" {
  uses = "maxheld83/ghactions_testthat@a2ffb9c63c98a76b5c6977097c53980de7d119ba"
  args = "testthat::test_dir(path = \"tests/testthat/\")"
  needs = "Install Dependencies"
}
