terraform {
  required_version = ">=0.14.10"
}

provider "aws" {
  region = var.region
}
