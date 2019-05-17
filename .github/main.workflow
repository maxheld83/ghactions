workflow "Build, Check, Document and Deploy" {
  on = "push"
  resolves = [
    "Check Package",
    "Build Website",
    "Deploy to GitHub Pages",
    "Code Coverage"
  ]
}

action "GCP Authenticate" {
  uses = "actions/gcloud/auth@04d0abbbe1c98d2d4bc19dc76bcb7754492292b0"
  secrets = ["GCLOUD_AUTH"]
}

action "Download Cache" {
  uses = "actions/gcloud/cli@d124d4b82701480dc29e68bb73a87cfb2ce0b469"
  runs = "gcloud config list" 
  needs = "GCP Authenticate"
}

action "Install Dependencies" {
  uses = "./actions/install-deps"
  needs = "Download Cache"
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
