workflow "Deploy on push" {
  on = "push"
  resolves = "Running Rscript"
}

action "Running Rscript" {
  uses = "./Rscript"
  args = "-e '1+1'"
}
