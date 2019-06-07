resource "aws_s3_bucket" "bucket" {
  bucket = "ramoni-mybucket"
  acl    = "private"

  tags = {
    Name        = "My Bucket"
  }
}

output "bucket_arn" { value = "${aws_s3_bucket.bucket.arn}" } 
#output "bucket_url" { value = "${aws_s3_bucket.bucket.website_endpoint}" } 
