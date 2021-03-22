# SECURITY GROUP
resource "aws_security_group" "lb" {
  name        = "lb"
  description = "security group for load balancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "lb_sg"
  }
}

resource "aws_security_group" "webserver" {
  name        = "ec2"
  description = "security group for ec2 webserver"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "webserver_sg"
  }
}

# SECURITY GROUP RULE
resource "aws_security_group_rule" "lb_ingres" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "lb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "webserver_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.lb.id
  security_group_id = aws_security_group.webserver.id
}

resource "aws_security_group_rule" "webserver_ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webserver.id 
}

resource "aws_security_group_rule" "webserver_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webserver.id
}