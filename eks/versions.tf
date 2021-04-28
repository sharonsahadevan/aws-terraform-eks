# terraform {
#   required_version = ">= 0.12.0"
# }

# provider "aws" {
#   version = ">= 2.28.1"
#   region = var.region
# }

# provider "random" {
#   version = "~> 2.1"
# }

# provider "local" {
#   version = "~> 1.2"
# }

# provider "null" {
#   version = "~> 2.1"
# }

# provider "template" {
#   version = "~> 2.1"
# }

# new version
# terraform {
#   required_version = ">= 0.13.1"

#   required_providers {
#     aws        = ">= 3.22.0"
#     local      = ">= 1.4"
#     null       = ">= 2.1"
#     template   = ">= 2.1"
#     random     = ">= 2.1"
#     kubernetes = "~> 1.11"
#   }
# }