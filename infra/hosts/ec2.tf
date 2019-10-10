# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY TWO EC2 INSTANCES THAT ALLOWS CONNECTIONS VIA SSH
# See test/terraform_ssh_example.go for how to write automated tests for this code.
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
}


# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE EC2 INSTANCE WITH A PUBLIC IP
# ---------------------------------------------------------------------------------------------------------------------
# module "tf_iam" {
#   source = "../iam"
# }

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

########################################
# Create Public Security Group
########################################
resource "aws_security_group" "sg_pub" {
  name = "tf_sg_${var.instance_name}_pub"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "${var.ssh_port}"
    to_port   = "${var.ssh_port}"
    protocol  = "tcp"

    # To keep this example simple, we allow incoming SSH requests from any IP. In real-world usage, you should only
    # allow SSH requests from trusted servers, such as a bastion host or VPN server.
    cidr_blocks = ["0.0.0.0/0"]
  }
}
########################################
#Get EC2 instance in the public subnet
########################################
resource "aws_instance" "ec2_pub" {
//  ami                    = "${data.aws_ami.ubuntu.id}"
  ami                    = "ami-00eb20669e0990cb4"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg_pub.id}"]
#  iam_instance_profile = "${module.tf_iam.s3_access_profile_name}"
  iam_instance_profile = "${data.terraform_remote_state.iam_info.s3_access_profile_name}"
  key_name               = "${var.key_pair_name}"
  user_data = <<-EOF
              #!/bin/bash
              cd /home/ec2-user/
              echo "My file" > myfile.txt
              sudo yum -y update
              sudo yum install -y ruby
              cd /home/ec2-user
              sudo curl -O https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
              sudo chmod +x ./install
              sudo ./install auto
              sudo service codedeploy-agent start
              sudo service codedeploy-agent status
              EOF


  # This EC2 Instance has a public IP and will be accessible directly from the public Internet
  associate_public_ip_address = true


  tags {
    Name = "tf_${var.instance_name}_pub"
  }

}



