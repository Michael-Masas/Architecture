resource "aws_security_group" "rds-sg" {
  name   = "mysql-sg"
  vpc_id = data.aws_vpc.default_vpc.id
}

// resource "aws_security_group_rule" "ingress-all" {
//   security_group_id = aws_security_group.rds-sg.id
//   from_port         = 0
//   to_port           = 0
//   protocol          = -1
//   type              = "ingress"
//   self              = true
// }

resource "aws_security_group_rule" "egress-all" {
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.rds-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "ingress-mysql" {
  security_group_id = aws_security_group.rds-sg.id
  from_port         = 0
  to_port           = 0
  protocol          = 3306
  type              = "ingress"
  self              = true
}

resource "aws_security_group_rule" "ingress-ssh" {
  security_group_id = aws_security_group.rds-sg.id
  from_port         = 0
  to_port           = 0
  protocol          = 22
  type              = "ingress"
  self              = true
}

resource "aws_security_group_rule" "ingress-ssh" {
  security_group_id = aws_security_group.rds-sg.id
  from_port         = 0
  to_port           = 0
  protocol          = 22
  type              = "ingress"
  self              = true
}