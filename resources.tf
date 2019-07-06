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
   count         = "${var.count}"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${data.template_file.user_data.rendered}"


  tags = {
    Name = "${format("webserver-%03d", count.index + 1)}"
  }
}

## Creating Launch Configuration
resource "aws_launch_configuration" "example" {
  image_id               = "${lookup(var.amis, var.aws_region)}"
  instance_type          = "t2.micro"
  security_groups        = ["${aws_security_group.sgweb.id}"]
  key_name               = "${aws_key_pair.default.id}"
  user_data              = "${data.template_file.user_data.rendered}"
  

  lifecycle {
    create_before_destroy = true
  }
}
## Creating AutoScaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["ap-south-1a", "ap-south-1b"]
  min_size = 2
  max_size = 4
  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"
  vpc_zone_identifier = ["${aws_subnet.public-subnet.id}"]
  tags = {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}
## Security Group for ELB
resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id="${aws_vpc.default.id}"
}
### Creating ELB
resource "aws_elb" "example" {
  name = "terraform-asg-example"
  security_groups = ["${aws_security_group.elb.id}", "${aws_security_group.sgweb.id}"]
  subnets = ["${aws_subnet.public-subnet.id}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}


