workflow "Build, Check and Document Package" {
  on = "push"
  resolves = "Document"
}

action "Build Image" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  args = "build --tag=repo:latest ."
}

action "Build and Check" {
  needs = "Build Image"
  uses = "./Rscript-byod"
  args = "-e 'devtools::check(error_on = \"note\")'"
}

action "Document" {
  needs = "Build and Check"
  uses = "./Rscript-byod"
  args = "-e 'pkgdown::build_site()'"
}
