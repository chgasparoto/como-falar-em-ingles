terraform {
  required_version = "~> 1.1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.66.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Application = "Como Falar Em Inglês"
      ManagedBy   = "Terraform"
      Owner       = "Cleber Gasparoto"
      Environment = var.environment
      GitRepo     = "https://github.com/chgasparoto/como-falar-em-ingles"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile
  alias   = "us-east-1"
}
