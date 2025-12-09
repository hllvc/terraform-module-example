{% if env == 'dev' %}
provider "aws" {
  region = "us-east-1"
}

# Caller 1: Basic module usage with simple inputs
module "app_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name        = var.bucket_name
  versioning_enabled = var.versioning_enabled

  tags = {
    Environment = "dev"
    Project     = "my-app"
  }
}

output "bucket_id" {
  value = module.app_bucket.bucket_id
}
{% endif %}
