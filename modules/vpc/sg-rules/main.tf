resource "aws_security_group_rule" "ingress" {
  for_each = { for i, rule in var.ingress_rules : i => rule }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = var.security_group_id
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "egress" {
  for_each = { for i, rule in var.egress_rules : i => rule }

  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = var.security_group_id
  cidr_blocks       = each.value.cidr_blocks
}
