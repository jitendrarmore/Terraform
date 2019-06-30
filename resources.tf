# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "terraform1"
  public_key = "${file("${var.key_path}")}"
}

data "template_file" "user_data" {
template = "${file("userdata.sh")}"
}

# Define webserver inside the public subnet
resource "aws_instance" "JitendraInterview-test" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${data.template_file.user_data.rendered}"


  tags = {
    Name = "webserver"
  }
}

