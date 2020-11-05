output "docker_registry" {
  value = aws_ecr_repository.app.repository_url
}

output "bucket" {
  value = module.tf_remote_state.bucket
}