variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = false
}

# for_each pattern
variable "buckets" {
  description = "Map of bucket configurations for for_each pattern"
  type = map(object({
    versioning_enabled = optional(bool, false)
  }))
  default = {
    "bucket1" = {
      versioning_enabled = true
    }
    "bucket2" = {
      versioning_enabled = false
    }
  }
}

# count pattern
variable "bucket_count" {
  description = "Number of buckets to create for count pattern"
  type        = number
  default     = 2
}
