resource "aws_connect_instance" "test" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled    = true
  instance_alias           = "my-instance-from-terraform"
  outbound_calls_enabled   = true

  tags = {
    "hello" = "world"
  }
}