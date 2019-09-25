output "public_instance_id" {
  value = "${aws_instance.ec2_pub.id}"
}

output "public_instance_ip" {
  value = "${aws_instance.ec2_pub.public_ip}"
}

/*output "private_instance_id" {
  value = "${aws_instance.example_public.id}"
}

output "private_instance_ip" {
  value = "${aws_instance.example_public.private_ip}"
}
*/