output "region" {
  value = var.region
}

output "repository_url" {
  value = module.fargate.repository_url
}

output "app" {
  value = var.app
}