## LAUNCH CONFIG
resource "aws_launch_configuration" "lc_app01-prod" {
  name = "lc_app01-prod"
  image_id = "ami-051b4811c67117b1b"
  instance_type = "t2.micro"
  security_groups = [
    "${aws_security_group.sg_app01.id}",
  ]
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = "10"
  }
}

## AUTOSCALING GROUP
resource "aws_autoscaling_group" "asg_app01-prod" {
  name = "asg_app01-prod"

  #availability_zones  = ["${aws_subnet.subnet_app01-prod_1a.availability_zone}"]
  availability_zones  = ["us-east-1a","us-east-1c"]
  #vpc_zone_identifier = ["${data.terraform_remote_state.vpc.private_subnets}"]

  #target_group_arns = [
  #  "${aws_elb_target_group.tg_app01-prod.arn}"
  #]

  load_balancers = [
    "${aws_elb.elb_app01-prod.id}",
  ]

  min_elb_capacity = "1"
  max_size         = "2"
  min_size         = "0"
  desired_capacity = "1"

  health_check_grace_period = 120
  health_check_type         = "ELB"

  force_delete = true
  wait_for_capacity_timeout = "5m"
  launch_configuration = "${aws_launch_configuration.lc_app01-prod.name}"
}



## TARGET GROUP
resource "aws_lb_target_group" "app01-prod" {
  name     = "app01-prod"
  port     = 22
  protocol = "TCP"
  vpc_id = "${aws_vpc.vpc_app01-prod.id}"

  health_check = [
    {
      interval            = 10
      protocol            = "TCP"
      healthy_threshold   = 2
      unhealthy_threshold = 2
    },
  ]
}

## ELB
resource "aws_elb" "elb_app01-prod" {
  #name     = "elb_app01-prod"
  internal = true
  subnets  = ["${aws_subnet.subnet_app01-prod_1a.id}","${aws_subnet.subnet_app01-prod_1c.id}"]

  #security_groups = [
  #  "${aws_security_group.payments_external_elb.id}",
  #  "${data.terraform_remote_state.vpc.sg_services}",
  #]

  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 10

  listener = [
    {
      instance_port      = "22"
      instance_protocol  = "TCP"
      lb_port            = "22"
      lb_protocol        = "TCP"
    },
  ]

  health_check = [
    {
      target              = "TCP:22"
      interval            = 31
      healthy_threshold   = 2
      unhealthy_threshold = 5
      timeout             = 30
    },
  ]

}


