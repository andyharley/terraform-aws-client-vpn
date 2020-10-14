output "client_vpn_endpoint_id" {
  description = "AWS Client VPN ID"
  value       = join("", aws_ec2_client_vpn_endpoint.default.*.id)
}
