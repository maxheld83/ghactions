workflow "Deploy on push" {
  on = "push"
  resolves = "Running Rscript"
}

action "Running Rscript" {
  uses = "./Rscript"
}
