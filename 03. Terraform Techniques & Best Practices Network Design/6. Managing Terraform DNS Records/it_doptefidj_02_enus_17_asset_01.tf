provider "aws" {
  region = "us-west-2"
}

# Define a Route 53 Hosted Zone
resource "aws_route53_zone" "example_zone" {
  name = "example.com"
}

# Create an A Record for the Root Domain (example.com)
resource "aws_route53_record" "root_domain_a_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "example.com"
  type    = "A"
  ttl     = 300
  records = ["192.0.2.1"]

  # Set up health check (optional)
  health_check_id = aws_route53_health_check.root_health_check.id
}

# Create a CNAME Record for a Subdomain (www.example.com)
resource "aws_route53_record" "www_cname_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "www.example.com"
  type    = "CNAME"
  ttl     = 300
  records = ["example.com"]
}

# Create an MX Record for Email
resource "aws_route53_record" "email_mx_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "example.com"
  type    = "MX"
  ttl     = 300
  records = [
    "10 mail1.example.com",
    "20 mail2.example.com"
  ]
}

# Create a TXT Record for Domain Verification (e.g., SPF)
resource "aws_route53_record" "spf_txt_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "example.com"
  type    = "TXT"
  ttl     = 300
  records = ["v=spf1 include:_spf.example.com ~all"]
}

# Create a Route 53 Health Check (optional)
resource "aws_route53_health_check" "root_health_check" {
  fqdn             = "example.com"
  type             = "HTTP"
  resource_path    = "/"
  failure_threshold = 3
}

