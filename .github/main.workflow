workflow "Build, compile and deploy" {
  on = "push"
  resolves = "1 Plus 1"
}

action "Build image" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  args = "build --tag=repo:latest ."
}

action "1 Plus 1" {
  needs = "Build image"
  uses = "./Rscript-byod"
  args = "-e '1+1'"
}
