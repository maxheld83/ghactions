workflow "Test Action" {
  on = "push",
  resolves = ["Hello World", "Shellcheck"]
}

action "Shellcheck" {
  uses = "actions/bin/shellcheck@1b3c130914f7b20890bf159306137d994a4c39d0"
  args = "*.sh"
}

action "Hello World" {
  uses = "./"
}
