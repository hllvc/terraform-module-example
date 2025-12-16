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

# Caller 1: Basic module usage with simple inputs
module "app_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name        = var.bucket_name
  versioning_enabled = var.versioning_enabled
}

output "bucket_id" {
  value = module.app_bucket.bucket_id
}

# Caller 2: for_each pattern
module "app_bucket_foreach" {
  source   = "../../modules/s3-bucket"
  for_each = var.buckets

  bucket_name        = "${var.bucket_name}-foreach-${each.key}"
  versioning_enabled = each.value.versioning_enabled
}

output "bucket_ids_foreach" {
  value = { for k, v in module.app_bucket_foreach : k => v.bucket_id }
}

# Caller 3: count pattern
module "app_bucket_count" {
  source = "../../modules/s3-bucket"
  count  = var.bucket_count

  bucket_name        = "${var.bucket_name}-count-${count.index}"
  versioning_enabled = var.versioning_enabled
}

output "bucket_ids_count" {
  value = module.app_bucket_count[*].bucket_id
}
