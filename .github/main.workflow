workflow "Build, Check, Document and Deploy" {
  on = "push"
  resolves = [
    "Build Image",
    "Document Package",
    "Code Coverage",
    "Deploy to GitHub Pages",
    "Install Package",
  ]
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

action "Install Package" {
  uses = "./Rscript-byod"
  needs = ["Build Package"]
  args = "-e 'devtools::install(dependencies = FALSE)'"
}

action "Check Package" {
  uses = "./Rscript-byod"
  needs = ["Build Package"]
  args = "-e 'devtools::check_built(error_on = \"warning\")'"
}

action "Document Package" {
  uses = "./Rscript-byod"
  needs = ["Install Package"]
  args = "-e 'pkgdown::build_site()'"
}

action "Code Coverage" {
  uses = "./Rscript-byod"
  needs = ["Build Package"]
  args = "-e 'covr::codecov()'"
  secrets = ["CODECOV_TOKEN"]
}

action "Filter Master Branch" {
  uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd"
  needs = ["Check Package", "Document Package"]
  args = "branch master"
}

action "Deploy to GitHub Pages" {
  uses = "maxheld83/ghpages@v0.1.1"
  env = {
    BUILD_DIR = "docs"
  }
  secrets = ["GH_PAT"]
  needs = ["Filter Master Branch"]
}
