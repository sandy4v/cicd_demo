
provider "aws" {
  region = "${var.aws_region}"
}
terraform {
  backend "s3" {}
}
resource "aws_iam_role" "codedeploy_service" {
  name = "${var.iamrolename}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
    "Sid": "",
    "Effect": "Allow",
    "Principal": {
    "Service": [
        "codedeploy.us-east-1.amazonaws.com",
        "codedeploy.us-west-2.amazonaws.com"
    ]
    },
    "Action": "sts:AssumeRole"
    }
 ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.codedeploy_service.name}"
}

