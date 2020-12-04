resource "aws_service_discovery_private_dns_namespace" "internal" {
  name        = "${var.env}.newaperio.internal"
  description = "The service discovery namespace for the app under newaperio.internal"
  vpc         = var.vpc_id

  tags        = {
    Terraform = true
  }
}

resource "aws_service_discovery_service" "service" {
  name = var.app

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.internal.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}