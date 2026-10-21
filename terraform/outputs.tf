output "cdn_ip" {
  value = module.statichosting.cdn_ip
}
output "cdn_url" {
  value = "http://${module.statichosting.cdn_ip}"
}
output "bucket" {
  value = module.statichosting.bucket
}
