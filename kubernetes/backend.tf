terraform {
  backend "remote" {
    organization = "sharon-demo"

    workspaces {
      name = "eks"
    }
  }
}