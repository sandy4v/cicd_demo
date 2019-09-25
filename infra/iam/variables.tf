
variable "iamrolename" { default = "tf_codedep_role"}
variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "us-east-1"
}