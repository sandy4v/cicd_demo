variable "codedepappname" { default = "cicd_demo"}
variable "depgroupname" { default = "dg_cicd_demo"}
variable "iamrolename" { default = "tf_codedep_role"}
variable "deptype" { default = "CodeDeployDefault.OneAtATime" }
variable "codedep_bckt_name" { default = "cicd_demo_codedep"}

variable "visibility" { default = "public"}
variable "env" { default = "dev"}

variable "instance_tag" {}