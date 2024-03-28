

provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "artash-s3"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
