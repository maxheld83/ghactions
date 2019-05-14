workflow "Build, Check, Document and Deploy" {
  on = "push"
  resolves = [
    "Check Package",
    "Document Package"
  ]
}

action "Install Dependencies" {
  uses = "./actions/install-deps"
}

action "Build Package" {
  uses = "./actions/build"
  needs = ["Install Dependencies"]
}

action "Check Package" {
  uses = "./actions/check"
  needs = ["Build Package"]
}

action "Document Package" {
  uses = "./actions/pkgdown"
  needs = ["Build Package"]
}
# 
# action "Code Coverage" {
#   uses = "./actions/rscript-byod"
#   needs = ["Build Package"]
#   args = "-e 'covr::codecov()'"
#   secrets = ["CODECOV_TOKEN"]
# }
# 
# action "Master Branch" {
#   uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd"
#   needs = ["Check Package", "Document Package"]
#   args = "branch master"
# }
# 
# action "Deploy to GitHub Pages" {
#   uses = "maxheld83/ghpages@v0.1.1"
#   env = {
#     BUILD_DIR = "docs"
#   }
#   secrets = ["GH_PAT"]
#   needs = ["Master Branch"]
# }
