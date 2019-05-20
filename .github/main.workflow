workflow "Build, Check, Document and Deploy" {
  on = "push"
  resolves = [
    "Upload Cache",
    "Code Coverage",
    "Check Package",
    "Build Website",
    "Deploy Website"
  ]
}

action "GCP Authenticate" {
  uses = "actions/gcloud/auth@04d0abbbe1c98d2d4bc19dc76bcb7754492292b0"
  secrets = [
    "GCLOUD_AUTH"
  ]
}

action "Download Cache" {
  uses = "actions/gcloud/cli@d124d4b82701480dc29e68bb73a87cfb2ce0b469"
  runs = "gsutil -m cp -r gs://ghactions-cache/lib.tar.gz /github/home/"
  needs = [
    "GCP Authenticate"
  ]
}

action "Decompress Cache" {
  uses = "actions/bin/sh@5968b3a61ecdca99746eddfdc3b3aab7dc39ea31"
  runs = "tar -zxf /github/home/lib.tar.gz --directory /github/home"
  needs = [
    "Download Cache"
  ]
}

action "Install Dependencies" {
  uses = "./actions/install-deps"
  needs = [
    "Decompress Cache"
  ]
}

action "Compress Cache" {
  uses = "actions/bin/sh@5968b3a61ecdca99746eddfdc3b3aab7dc39ea31"
  runs = "tar -zcf lib.tar.gz --directory /github/home lib"
  needs = [
    "Install Dependencies"
  ]
}

action "Upload Cache" {
  uses = "actions/gcloud/cli@d124d4b82701480dc29e68bb73a87cfb2ce0b469"
  runs = "gsutil -m cp lib.tar.gz gs://ghactions-cache/"
  needs = [
    "Compress Cache"
  ]
}

action "Build Package" {
  uses = "./actions/build"
  needs = [
    "Install Dependencies"
  ]
}

action "Code Coverage" {
  uses = "./actions/covr"
  needs = [
    "Build Package"
  ]
  secrets = [
    "CODECOV_TOKEN"
  ]
}

action "Check Package" {
  uses = "./actions/check"
  needs = [
    "Build Package"
  ]
}

action "Install Package" {
  uses = "./actions/install"
  needs = [
    "Build Package"
  ]
}

action "Build Website" {
  uses = "./actions/pkgdown"
  needs = [
    "Install Package"
  ]
}

action "Master Branch" {
  uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd"
  needs = [
    "Check Package", 
    "Build Website"
  ]
  args = "branch master"
}	

action "Deploy Website" {
  uses = "maxheld83/ghpages@v0.1.1"
  env = {
    BUILD_DIR = "docs"
  }
  secrets = ["GH_PAT"]
  needs = [
    "Master Branch"
  ]
}
