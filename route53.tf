# Create Domain Name System /////////////////////////////////////

resource "aws_route53_record" "artash_dns" {
  zone_id = "Z10299161M47DBD68JOWT"
  name    = "artash_dns"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.artash_alb.dns_name]
}
