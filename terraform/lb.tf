resource "aws_elb" "lb" {
  name               = "webserver-lb"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_c.id]
  security_groups    = [aws_security_group.lb.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "webserver_lb"
  }
}
