#------------------------------[Zone Registration]------------------------------

resource "aws_route53_zone" "website" {
  name          = var.domain
  comment       = "${var.project_name} hosted zone"
  force_destroy = false
  tags          = merge(var.tags, { Name = var.domain })
  lifecycle {
    create_before_destroy = true
  }
}

#-----------------------------------[Records]-----------------------------------

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.website.id
  name    = var.domain
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "spf" {
  zone_id = aws_route53_zone.website.id
  name    = var.domain
  type    = "TXT"
  records = var.spf
  ttl     = 21600
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dmarc" {
  zone_id = aws_route53_zone.website.id
  name    = "_dmarc"
  type    = "TXT"
  records = var.dmarc
  ttl     = 21600
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dkim" {
  zone_id = aws_route53_zone.website.id
  name    = "mail._domainkey"
  type    = "TXT"
  records = var.dkim
  ttl     = 21600
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.website.id
  name    = var.domain
  type    = "MX"
  records = var.mx
  ttl     = 21600
  lifecycle {
    create_before_destroy = true
  }
}
