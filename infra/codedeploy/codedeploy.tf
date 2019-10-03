

########################################
#Get Config for IAM roles
########################################
variable "iam_key" {
    default="tfstate/cicd-demo/iam/terraform.tfstate"
}

data "terraform_remote_state" "iam_info" {
    backend = "s3"
    config = {
        bucket  = "${var.s3_tf_bckt_name}"
        key     = "${var.iam_key}"
        region  = "${var.aws_region}"
    }

}

# ---------------------------------------------------------------------------------------------------------------------
# S3 bucket for CodeDeploy artifact store
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "codedeploy_s3_bucket" {
  bucket = "${var.s3_tf_codedep_bckt_name}"
  tags = {
    Name        = "${var.s3_tf_coddep_bckt_name}"
    Environment = "${var.env}"
  }
  versioning {
    enabled = true
}
}
# create a AWS Code Deploy Application
resource "aws_codedeploy_app" "codedeploy_app0" {
  name = "${var.codedepappname}"
}
# create a AWS Code deployment group
resource "aws_codedeploy_deployment_group" "codedepgroup" {
  app_name              = "${aws_codedeploy_app.codedeploy_app0.name}"
  deployment_group_name = "${var.depgroupname}"
  service_role_arn = "${data.terraform_remote_state.iam_info.iam_cd_service_role_arn}"

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

