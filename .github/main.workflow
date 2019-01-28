workflow "Deploy on push" {
  on = "push"
  resolves = "Running Rscript"
}

action "Running Rscript" {
  uses = "./Rscript"
  env = {
    FROM = "rocker/verse:3.5.2"
  }
  args = "-e '1+1'"
}
