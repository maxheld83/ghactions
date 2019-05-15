workflow "Build, Check, Document and Deploy" {
  on = "push"
  resolves = [
    "Check Package",
    "Build Website",
    "Deploy to GitHub Pages",
    "Code Coverage"
  ]
}

action "Build Image" {
  uses = "actions/docker/cli@aea64bb1b97c42fa69b90523667fef56b90d7cff"
  args = [
    "build --tag=repo:latest ."
  ]
}

action "Install Dependencies" {
  uses = "./actions/install-deps"
  needs = "Build Image"
}

action "Build Package" {
  uses = "./actions/build"
  needs = ["Install Dependencies"]
}

action "Code Coverage" {
  uses = "./actions/covr"
  needs = ["Build Package"]
  secrets = ["CODECOV_TOKEN"]
}

action "Check Package" {
  uses = "./actions/check"
  needs = ["Build Package"]
}

action "Install Package" {
  uses = "./actions/install"
  needs = ["Build Package"]
}

action "Build Website" {
  uses = "./actions/pkgdown"
  needs = ["Install Package"]
}

action "Master Branch" {
  uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd"
  needs = ["Check Package", "Build Website"]
  args = "branch master"
}

action "Deploy to GitHub Pages" {
  uses = "maxheld83/ghpages@v0.1.1"
  env = {
    BUILD_DIR = "docs"
  }
  secrets = ["GH_PAT"]
  needs = ["Master Branch"]
}
