output "security_group" {
    value = module.fargate.service_sg_id
}

output "repository_url" {
    value = aws_ecr_repository.ecr.repository_url
}