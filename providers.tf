provider "random" {}

terraform {
  required_version = "1.9.8"
}

provider "aws" {
  region              = "ap-southeast-4"
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
}