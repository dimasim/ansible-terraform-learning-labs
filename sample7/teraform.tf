terraform {
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0" # Menggunakan versi sandbox agar optimal dengan LocalStack
    }
  }
}