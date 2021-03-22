data "template_cloudinit_config" "webserver_data" {
  part {
    content_type = "text/cloud-config"

    content = <<EOF
write_files:
 - content: |
     ${base64encode(file("nginx.service"))}
   encoding: b64
   owner: root:root
   path: /etc/systemd/system/nginx.service
   permissions: '0744'
 - content: |
     ${base64encode(file("../click/index.html"))}
   encoding: b64
   owner: root:root
   path: /tmp/index.html
   permissions: '0744'
 - content: |
     ${base64encode(file("../click/index.css"))}
   encoding: b64
   owner: root:root
   path: /tmp/index.css
   permissions: '0744'
 - content: |
     ${base64encode(file("../click/click.js"))}
   encoding: b64
   owner: root:root
   path: /tmp/click.js
   permissions: '0744'
EOF

  }

  part {
    filename     = "bootstrap.sh"
    content_type = "text/x-shellscript"
    content      = file("bootstrap.sh")
  }
}

resource "aws_autoscaling_group" "webserver" {
  name_prefix               = "webserver"
  max_size                  = 1
  min_size                  = 0
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  lifecycle {
    create_before_destroy = true
  }

  load_balancers       = [aws_elb.lb.id]
  launch_configuration = aws_launch_configuration.webserver.name
  vpc_zone_identifier  = [aws_subnet.public_a.id]

  tag {
    key                 = "Name"
    value               = "webserver"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "webserver" {
  name_prefix          = "webserver"
  image_id             = "ami-0fa37863afb290840"
  instance_type        = "t3.nano"
  key_name             = "click"
  iam_instance_profile = aws_iam_instance_profile.webserver.name
  security_groups      = [aws_security_group.webserver.id]

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    delete_on_termination = "true"
    volume_size           = "8"
    volume_type           = "gp2"
  }

  user_data = data.template_cloudinit_config.webserver_data.rendered
}

resource "aws_eip" "webserver" {
  vpc = true

  tags = {
    Name = "webserver ip"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat eip"
  }
}
