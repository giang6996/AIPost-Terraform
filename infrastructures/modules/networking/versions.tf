terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # Follow module-provider ownership model
      version = ">= 6.0"
    }
  }
}