variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "your-gcp-project-id"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "project_name" {
  description = "Name prefix applied to all resources"
  type        = string
  default     = "ahmad-static"
}
