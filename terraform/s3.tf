data "template_file" "s3-public-policy" {
  template = file("s3-public-policy.json")
  vars = {
    bucket_name = var.domain
    cdn_oai     = aws_cloudfront_origin_access_identity.this.id
  }
}

module "logs" {
  source = "github.com/chgasparoto/terraform-s3-object-notification"
  name   = "${var.domain}-logs"
  acl    = "log-delivery-write"
}

module "website" {
  source = "github.com/chgasparoto/terraform-s3-object-notification"
  name   = var.domain
  acl    = "public-read"
  policy = data.template_file.s3-public-policy.rendered

  versioning = {
    enabled = true
  }

  filepath = "${local.website_filepath}/build"
  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  logging = {
    target_bucket = module.logs.name
    target_prefix = "access/"
  }
}

module "redirect" {
  source = "github.com/chgasparoto/terraform-s3-object-notification"
  name   = "www.${var.domain}"
  acl    = "public-read"


  website = {
    redirect_all_requests_to = var.domain
  }
}
