terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region              = "ap-southeast-4"
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
}

provider "random" {}



