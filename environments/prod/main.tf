terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Caller 2: Module with different inputs + additional resource
module "app_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name        = var.bucket_name
  versioning_enabled = var.versioning_enabled

  tags = {
    Environment = "prod"
    Project     = "my-app"
  }
}

# Additional resource: Bucket policy (only in prod)
resource "aws_s3_bucket_policy" "app_bucket_policy" {
  bucket = module.app_bucket.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceTLS"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          module.app_bucket.bucket_arn,
          "${module.app_bucket.bucket_arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

output "bucket_id" {
  value = module.app_bucket.bucket_id
}

output "bucket_arn" {
  value = module.app_bucket.bucket_arn
}
