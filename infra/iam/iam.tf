
provider "aws" {
  region = "${var.aws_region}"
}
terraform {
  backend "s3" {}
}
# Creates IAM role to give access to code deploy service to read asg and ec2 tags
# Role policy is created inline
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
#attach the role to the codedeploy service
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.codedeploy_service.name}"
}


#Create an IAM role to grant EC2 full access on S3

#create role that allows to assume role to EC2
resource "aws_iam_role" "s3_access_role" {
  name = "${var.s3_access_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

# Role policy that allows access on s3 objects
resource "aws_iam_role_policy" "s3_access_policy" {
  name = "${var.s3_access_policy_name}"
  role = "${aws_iam_role.s3_access_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
#to link the above role to aws ec2 instance we need a instance profile
resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "${var.s3_access_profile_name}"
  role = "${aws_iam_role.s3_access_role.name}"
}