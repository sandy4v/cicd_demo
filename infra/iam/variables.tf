
variable "iamrolename" { default = "cicd_codedep_role"}
variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "us-east-1"
}

variable "s3_access_role_name" { default = "cicd_s3access_role"}
variable "s3_access_policy_name" { default = "cicd_s3access_policy"}
variable "s3_access_profile_name" { default = "cicd_s3_profile"}