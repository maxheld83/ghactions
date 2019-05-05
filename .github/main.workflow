workflow "Say hi" {
  on = "push",
  resolves = ["Hello World"]
}

action "Hello World" {
  uses = "./"
}
