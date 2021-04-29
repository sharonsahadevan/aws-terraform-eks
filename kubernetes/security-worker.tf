data "aws_security_group" "worker_sg" {
  id = module.eks.worker_security_group_id
}

resource "aws_security_group_rule" "inbound_https" {
  from_port         = 32443
  protocol          = "tcp"
  security_group_id = data.aws_security_group.worker_sg.id
  to_port           = 32443
  type              = "ingress"
  source_security_group_id = var.alb_security_group_id
  description = "Allow Ingress from the ALB to the NodePorts"
}
