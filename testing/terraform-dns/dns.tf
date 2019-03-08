resource "aws_route53_zone" "team01" {
  name = "team01.andreramoni.com.br"
}

resource "aws_route53_record" "team01_ns" {
  zone_id = "Z3E551J13ONVZX"
  name    = "${aws_route53_zone.team01.name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.team01.name_servers.0}",
    "${aws_route53_zone.team01.name_servers.1}",
    "${aws_route53_zone.team01.name_servers.2}",
    "${aws_route53_zone.team01.name_servers.3}",
  ]
}


