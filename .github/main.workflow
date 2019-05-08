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
  uses = "maxheld83/ghactions_check@78652ea60553d2fd92d256876cd2873264cb9233"
  args = "testthat::test_dir(path = \"tests/testthat/\", stop_on_failure = TRUE)"
  needs = "Install Dependencies"
}
