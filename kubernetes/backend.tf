terraform {
  backend "remote" {
    organization = "sharon-sahadevan"

    workspaces {
      name = "eks"
    }
  }
}