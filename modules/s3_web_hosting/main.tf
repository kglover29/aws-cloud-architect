provider "aws" {
  region                   = "${var.Region}"
  shared_credentials_file  = "${var.CredsFile}"
  profile                  = "${var.Profile}"
}

data "aws_s3_bucket" "selected" {
  bucket = "bucket.test.com"
}

data "aws_route53_zone" "test_zone" {
  name = "test.com."
}

resource "aws_route53_record" "example" {
  zone_id   = "${data.aws_route53_zone.test_zone.id}"
  name      = "bucket"
  type      = "A"

  alias {
    name    = "${data.aws_s3_bucket.selected.website_domain}"
    zone_id = "${data.aws_s3_bucket.selected.hosted_zone_id}"
  }
}

data "aws_s3_bucket" "selected" {
  bucket = "a-test-bucket"
}

resource "aws_cloudfront_distribution" "test" {
  origin {
    domain_name = "${data.aws_s3_bucket.selected.bucket_domain_name}"
    origin_id   = "s3-selected-bucket"
  }
}
