terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.58.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "spikes"

    workspaces {
      prefix = "actions-and-terraform-pipeline-"
    }
  }
}