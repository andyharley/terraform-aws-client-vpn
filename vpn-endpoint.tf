resource "aws_ec2_client_vpn_endpoint" "default" {
  description            = "${var.name}-Client-VPN"
  server_certificate_arn = aws_acm_certificate.server.arn
  client_cidr_block      = var.cidr

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.root.arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.vpn.name
  }

  split_tunnel = var.split_tunnel

  tags = merge(
    var.tags,
    map(
      "Name", "${var.name}-Client-VPN",
      "EnvName", var.name
    )
  )
}

resource "aws_ec2_client_vpn_network_association" "default" {
  for_each               = var.subnet_ids
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  subnet_id              = each.value
}
