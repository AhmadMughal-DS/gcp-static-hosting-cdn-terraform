locals {
  name_prefix = var.project_name
}

module "statichosting" {
  source      = "./modules/statichosting"
  name_prefix = local.name_prefix
  project_id  = var.project_id
  environment = var.environment
}
