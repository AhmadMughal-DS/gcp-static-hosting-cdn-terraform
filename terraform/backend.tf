# Remote state backend (production). Create a GCS bucket with versioning, then
# uncomment and run `terraform init -migrate-state`.
#
# terraform {
#   backend "gcs" {
#     bucket = "ahmad-tfstate"
#     prefix = "gcp-static-hosting-cdn-terraform"
#   }
# }
