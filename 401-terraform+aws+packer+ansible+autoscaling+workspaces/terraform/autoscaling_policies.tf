# Scale UP:
resource "aws_autoscaling_policy" "app01-scale-up" {
  name = "app01-scale-up"
  autoscaling_group_name = "${aws_autoscaling_group.app01_asg.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "2"
  cooldown = "30"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "app01-cpu-alarm-up" {
  alarm_name = "app01-cpu-alarm-up"
  alarm_description = "app01-cpu-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "3"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.app01_asg.name}"
  }
  actions_enabled = true
  alarm_actions = ["${aws_autoscaling_policy.app01-scale-up.arn}"]
}


# scale down
  resource "aws_autoscaling_policy" "app01-scale-down" {
  name = "app01-scale-down"
  autoscaling_group_name = "${aws_autoscaling_group.app01_asg.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "-1"
  cooldown = "60"
  policy_type = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "app01-cpu-alarm-down" {
  alarm_name = "app01-cpu-alarm-down"
  alarm_description = "app01-cpu-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "3"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.app01_asg.name}"
  }
  actions_enabled = true
  alarm_actions = ["${aws_autoscaling_policy.app01-scale-down.arn}"]
}

