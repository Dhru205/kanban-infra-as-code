resource "aws_s3_bucket" "b" {
  bucket = "${var.environment_name}-${var.project_name}"
  acl    = "private"

  tags = {
    Owner                  = "${var.environment_name}"
    Environment            = "Dev"
    Versioning             = "Yes"
    CrossRegionReplication = "No"
    Public                 = "No"
    AccessLogging          = "No"
    Project                = "${var.project_name}"
  }
}
