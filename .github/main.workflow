workflow "Build, Check and Deploy" {
  on = "push"
  resolves = [
    "Upload Cache",
    "Code Coverage",
    "Deploy Website",
    "Push Base Image"
  ]
}

action "Build Action Images" {
  uses = "actions/action-builder/docker@abd46f08f3ae51e9386b1f9b6facd8bbd8a8c458"
  runs = "make"
  args = [
    "--directory=actions",
    "build"
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
    "Decompress Cache",
    "Build Action Images"
  ]
}

action "Compress Cache" {
  uses = "actions/bin/sh@5968b3a61ecdca99746eddfdc3b3aab7dc39ea31"
  runs = "tar -zcf lib.tar.gz --directory /github/home lib"
  needs = [
    "Install Dependencies"
  ]
}

action "Document Package" {
  uses = "./actions/document"
  needs = [
    "Install Dependencies"
  ]
}

action "Build Package" {
  uses = "./actions/build"
  needs = [
    "Document Package"
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

action "Filter Not Act" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  args = "not actor nektos/act"
  needs = [
    "Check Package", 
    "Build Website"
  ]
}

action "Filter Master" {
  uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd"
  needs = [
    "Upload Cache",
    "Code Coverage"
  ]
  args = "branch master"
}

action "Upload Cache" {
  uses = "actions/gcloud/cli@d124d4b82701480dc29e68bb73a87cfb2ce0b469"
  runs = "gsutil -m cp lib.tar.gz gs://ghactions-cache/"
  needs = [
    "Compress Cache",
    "Filter Not Act"
  ]
}

action "Docker Login" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  secrets = [
    "DOCKER_USERNAME",
    "DOCKER_PASSWORD"
  ]
  needs = [
    "Build Action Images",
    "Filter Not Act",
    "Filter Master"
  ]
}

action "Push Base Image" {
  uses = "actions/action-builder/docker/@abd46f08f3ae51e9386b1f9b6facd8bbd8a8c458"
  runs = "make"
  args = [
    "--directory=actions",
    "publish"
  ]
  needs = [
    "Docker Login"
  ]
}

action "Code Coverage" {
  uses = "./actions/covr"
  needs = [
    "Filter Not Act"
  ]
  secrets = [
    "CODECOV_TOKEN"
  ]
}

action "Deploy Website" {
  uses = "maxheld83/ghpages@v0.1.1"
  env = {
    BUILD_DIR = "docs"
  }
  secrets = ["GH_PAT"]
  needs = [
    "Filter Master"
  ]
}
