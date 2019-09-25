variable "codedepappname" { default = "cicd_demo"}
variable "depgroupname" { default = "dg_cicd_demo"}
variable "iamrolename" { default = "tf_codedep_role"}
variable "deptype" { default = "CodeDeployDefault.OneAtATime" }
variable "s3_tf_bckt_name" { default = "tf-s3-state-bucket"}

variable "visibility" { default = "public"}
variable "s3_bckt_name" {}
variable "env" { default = "dev"}

variable "instance_tag" {}