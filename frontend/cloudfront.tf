resource "aws_cloudfront_distribution" "cloud_front" {
  origin {
    domain_name = module.s3_bucket.s3_bucket_website_endpoint
    origin_id   = "S3-website-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution"
  default_root_object = "index.html"

}
