variable "project_id" {
  type    = string
  default = "your-gcp-project-id"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "project_name" {
  type    = string
  default = "ahmad-static"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}$", var.project_name))
    error_message = "project_name must be lowercase alphanumeric/hyphens, 2-31 chars."
  }
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}
