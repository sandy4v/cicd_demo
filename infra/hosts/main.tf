# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY TWO EC2 INSTANCES THAT ALLOWS CONNECTIONS VIA SSH
# See test/terraform_ssh_example.go for how to write automated tests for this code.
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {

    bucket = "tf-s3-state-bucket"
    key    = "tfstate/cicd-demo/hosts/terraform.tfstate"
    region = "us-east-1"

}}
# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE EC2 INSTANCE WITH A PUBLIC IP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "sg_pub" {
  name = "tf_sg_${var.instance_name}_pub"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

resource "aws_instance" "ec2_pub" {
//  ami                    = "${data.aws_ami.ubuntu.id}"
  ami                    = "ami-00eb20669e0990cb4"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg_pub.id}"]
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

/*
# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE EC2 INSTANCE WITH A PRIVATE IP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "example_private" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.example.id}"]
  key_name               = "${var.key_pair_name}"

  # This EC2 Instance has a private IP and will be accessible only from within the VPC
  associate_public_ip_address = false

  tags {
    Name = "${var.instance_name}-private"
  }
}
*/
# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT OF THE EC2 INSTANCES
# ---------------------------------------------------------------------------------------------------------------------


/*
# ---------------------------------------------------------------------------------------------------------------------
# LOOK UP THE LATEST UBUNTU AMI
# ---------------------------------------------------------------------------------------------------------------------

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}
*/
