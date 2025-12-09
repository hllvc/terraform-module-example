{% if env == 'dev' %}
provider "aws" {
  region = "us-east-1"
}

# Caller 1: Basic module usage with simple inputs
module "app_bucket" {
  source = ".."

  bucket_name        = var.bucket_name
  versioning_enabled = var.versioning_enabled
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

output "bucket_id" {
  value = module.app_bucket.bucket_id
}
{% endif %}
