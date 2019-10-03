# create a deployment group
resource "aws_codedeploy_app" "codedeploy_app0" {
  name = "${var.codedepappname}"
}
# create a deployment group
resource "aws_codedeploy_deployment_group" "codedepgroup" {
  app_name              = "${aws_codedeploy_app.codedeploy_app0.name}"
  deployment_group_name = "${var.depgroupname}"
  service_role_arn      = "${aws_iam_role.codedeploy_service.arn}"

  deployment_config_name = "${var.deptype}" # AWS defined deployment config

  ec2_tag_filter = {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "${var.instance_tag}"
  }

  # trigger a rollback on deployment failure event
  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 bucket for CodeDeploy artifact store
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "codedeploy_s3_bucket" {
  bucket = "${var.s3_tf_bckt_name}"
  tags = {
    Name        = "${var.s3_tf_bckt_name}"
    Environment = "${var.env}"
  }
  versioning {
    enabled = true
}
}