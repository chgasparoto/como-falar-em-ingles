output "website-url" {
  value = var.domain
}

output "cdn-url" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "distribution-id" {
  value = aws_cloudfront_distribution.this.id
}

output "api-url" {
  value = local.sub_domain_name
}
