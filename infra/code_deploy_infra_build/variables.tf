variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "us-east-1"
}
variable "codedepappname" { default = "cicd_demo"}
variable "depgroupname" { default = "dg_cicd_demo"}
variable "iamrolename" { default = "tf_codedep_role"}
variable "deptype" { default = "CodeDeployDefault.OneAtATime" }
variable "s3_tf_bckt_name" { default = "tf-s3-state-bucket"}
variable "s3_tf_codedep_bckt_name" { default = "codedeploy-cicd-demo"}

variable "visibility" { default = "public"}
variable "env" { default = "dev"}

variable "tag_filter_key"	    { default = "Name" }
variable "tag_filter_value"	    { default = "appserver" }