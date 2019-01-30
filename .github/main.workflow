workflow "Build and Check Package" {
  on = "push"
  resolves = "Check Package"
}

action "Build Image" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  args = "build --tag=repo:latest ."
}

action "Build Package" {
  needs = "Build Image"
  uses = "./Rscript-byod"
  args = "-e 'devtools::build()'"
}

action "Check Package" {
  needs = "Build Package"
  uses = "./Rscript-byod"
  args = "-e 'devtools::check_built(error_on = \"note\")'"
}
