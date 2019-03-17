resource "aws_route53_record" "elb" {
  zone_id = "Z3E551J13ONVZX"
  name    = "app01-${terraform.workspace}"
  type    = "A"

  alias {
    name                   = "${aws_elb.app01_elb.dns_name}"
    zone_id                = "${aws_elb.app01_elb.zone_id}"
    evaluate_target_health = true
  }
}
output "dns_name" { value = "${aws_route53_record.elb.fqdn}" }


