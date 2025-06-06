## route53 zone

resource "aws_route53_zone" "route53_zone" {
  name = "${var.project_name}.world"
  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.region
  }
}

resource "aws_route53_record" "example_alias_record" {
  zone_id = aws_route53_zone.route53_zone.id # ID of the existing hosted zone for your domain
  name    = var.environment_name             # Subdomain or record name
  type    = "A"                              # A record type

  alias {
    name                   = var.alb_dns_name # ALB DNS name
    zone_id                = var.zone_id      # Hosted zone ID of the ALB in ap-south-1 (Mumbai)
    evaluate_target_health = true             # Enable health check on the alias target
  }

  # Optional: add a routing policy if required (default is simple routing)
}
