provider "random" {}

provider "aws" {
  region                = "ap-southeast-4"
  shared_credentials_file = var.tfc_aws_dynamic_credentials.shared_credentials_file
}