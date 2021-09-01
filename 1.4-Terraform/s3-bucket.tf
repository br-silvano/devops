resource "aws_s3_bucket" "dev4" {
  bucket = "br.silvano-dev4"
  acl    = "private"

  tags = {
    Name        = "br.silvano-dev4"
  }
}
