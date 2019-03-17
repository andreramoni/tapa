### Launch configuration:
resource "aws_launch_configuration" "app01_lc" {
  name = "app01_lc-${terraform.workspace}-${data.aws_ami.app01_ami.id}"
  image_id = "${data.aws_ami.app01_ami.id}"
  key_name = "${aws_key_pair.kp01.id}"
  instance_type = "${var.instance_type}"
  security_groups = [
    "${aws_security_group.sg01.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "10"
  }
}
output "launch_configuration" { value = "${aws_launch_configuration.app01_lc.id}" }

## Autoscaling group
resource "aws_autoscaling_group" "app01_asg" {
  name = "asg-${aws_launch_configuration.app01_lc.name}"

  vpc_zone_identifier = [
                         "${aws_subnet.subnet01.id}",
                         "${aws_subnet.subnet02.id}"
                        ]
  wait_for_capacity_timeout = "10m"

  load_balancers = [
    "${aws_elb.app01_elb.id}"
  ]
  
  tags = [
    {
      key                 = "Name"
      value               = "app01-${terraform.workspace}"
      propagate_at_launch = true
    },
  ]
  min_elb_capacity = "2"
  max_size         = "10"
  min_size         = "2"
  #desired_capacity = "2"

  health_check_grace_period = 300
  health_check_type         = "ELB"

  force_delete = true

  launch_configuration = "${aws_launch_configuration.app01_lc.name}"

  lifecycle {
    create_before_destroy = true
  }
}
output "autoscaling_group" { value = "${aws_autoscaling_group.app01_asg.id}" }

## ELB
resource "aws_elb" "app01_elb" {
  name     = "app01-elb-${terraform.workspace}"
  internal = false
  subnets  = ["${aws_subnet.subnet01.id}", "${aws_subnet.subnet02.id}"]

  security_groups = [
    "${aws_security_group.sg01.id}",
  ]

  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 120

  listener = [
    {
      instance_port      = "80"
      instance_protocol  = "HTTP"
      lb_port            = "80"
      lb_protocol        = "HTTP"
    },
  ]

  health_check = [
    {
      #target              = "HTTP:80/"
      target              = "TCP:80"
      interval            = 10
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]

}
output "elb_name" { value = "${aws_elb.app01_elb.dns_name}" }
#output "elb_instances" { value = "${aws_elb.app01_elb.instances}" }

##############
# ELB ROUTE 53
##############

#resource "aws_route53_record" "elb_banking_accounts" {
#  zone_id = "${var.domain_zone_id}"
#  name    = "${var.environment == "production" ? "banking-accounts-internal" : "banking-accounts-internal.${var.environment}" }"
#  type    = "A"
#
#  alias {
#    name                   = "${aws_elb.banking-accounts.dns_name}"
#    zone_id                = "${aws_elb.banking-accounts.zone_id}"
#    evaluate_target_health = true
#  }
#}

