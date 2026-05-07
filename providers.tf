terraform {
  backend "s3" {
    bucket = "todayisfridaymaybe"
    key = "infra/terraform.tfstate"
    region = "ap-northeast-2"
  }
  required_providers {
    aws = {                 
      source  = "hashicorp/aws"
      version = "~> 5.0"  
    }
  }

  required_version = ">=1.0"
}

provider "aws" {
  region = "ap-northeast-2" # 서울 리전
}