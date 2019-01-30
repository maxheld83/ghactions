workflow "Build and Check" {
  on = "push"
  resolves = "Check"
}

action "Build Image" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  args = "build --tag=repo:latest ."
}

action "Check" {
  needs = "Build Image"
  uses = "./Rscript-byod"
  args = "-e 'devtools::check(error_on = \"note\")'"
}
