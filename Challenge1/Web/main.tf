#______________________________________Web Tier_________________________________
#_________________________________Configure Provider Credentials________________
provider "aws"{
  region = var.region
  shared_redentials_file = "~/.aws/credentials"
}

#______________________________________AMI______________________________________

data "aws_ami" "web_ami_external" {
  most_recent = true
  filter {
    name   = "tag:Name"
    values = ["${var.web_ami_name}"]
  }
  filter {
    name   = "tag:Lifecycle"
    values = ["authorised"]
  }
}

#____________________________Data Source For User Data__________________________

data "template" "userdata" {
  template = "${file("${var.userdatatype}")}"

  vars {
    vault_environment       = "${var.tag_environment}"
    tag_environment         = "${var.tag_environment}"
    vault_addr              = "${var.vault_addr}"
    vault_app_role          = "${var.vault_web_role}"
    domain_join_user        = "${var.domain_join_user}"
    domain_join_password    = "${var.domain_join_password}"
    ou_path                 = "${var.web_ou_path}"
    myappear_location       = "${var.myappzip_location}"
    asg_name                = "${var.asg_web_name}"
    logs_bucket_name        = "${var.logs_bucket_name}"
    no_proxy                = "${var.no_proxy}"
    admin_group      = "${var.admin_group}"
    developer_group  = "${var.developer_group}"
  }
} 

#________________Web EC2 Instances___________________________
resource "aws_instance" "webserver1" {
  ami                    = ""
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  subnet_id              = aws_subnet.web-subnet-1.id
  user_data              = file("install_apache.sh")

  tags = {
    Name = "Web Server"
  }

}

resource "aws_instance" "webserver2" {
  ami                    = "ami-0d5eff06f840b45e9"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1b"
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  subnet_id              = aws_subnet.web-subnet-2.id
  user_data              = file("install_apache.sh")

  tags = {
    Name = "Web Server"
  }

}
  
#____________________________Web load balancer external_________________________

resource "aws_lb" "external-alb" {
  name               = "External-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sg.id]
  subnets            = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]
  tags {
   Name                       = "${var.stack_name}-web-ALB-ext-${var.tag_environment}"
   tag_environment            = "${var.tag_environment}"
   team                       = "${var.tag_team}"
 }
}
resource "aws_lb_target_group" "external-alb-tg" {
  name     = "ALB-TG"
  port     = "${var.port_80}"
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
  deregistration_delay       = "${var.web_tg_deregistration_delay}"
  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = "${var.web_tg_cookie_duration}"
  }

  health_check {
    interval            = "${var.web_tg_check_interval}"
    path                = ""
    timeout             = ""
    healthy_threshold   = "${var.web_tg_healthy_threshold}"
    unhealthy_threshold = "${var.web_tg_unhealthy_threshold}"
    matcher             = ""
  }
  tags {
.....
  }
} 

resource "aws_lb_target_group_attachment" "external-alb1" {
  target_group_arn = aws_lb_target_group.external-alb-tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80

  depends_on = [
    aws_instance.webserver1,
  ]
}

resource "aws_lb_target_group_attachment" "external-alb2" {
  target_group_arn = aws_lb_target_group.external-alb-tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80

  depends_on = [
    aws_instance.webserver2,
  ]
}
 
resource "aws_lb_listener" "web_alb_listener" {
  provider = "aws.client"
  load_balancer_arn = "${aws_lb.external-alb.arn}"
  protocol          = "HTTPS"
  port            = "${var.port_cccc}"
  ssl_policy      = "${var.listener_ssl_policy}"
  certificate_arn = "${var.listener_certificate_arn}"
  default_action {
    target_group_arn = "${aws_lb_target_group.external-alb-tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "web_alb_listener_rule" {
  listener_arn     = "${aws_lb_listener.web_alb_listener.arn}"
  priority         = "${var.web_priority_9999}"
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.external-alb-tg.arn}"
  }
  condition {
    field  = "${var.web_listener_rule_field}"
    values = ["${var.web_listener_rule_values}"]
  }
} 

#_________________________ASG_________________________________

resource "aws_autoscaling_group" "asg_external" {
  
  asg_web_internal_name = "asg-web"
  # ... other configuration ...

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  elb                    = aws_lb.external-alb.id
}
 
resource "aws_autoscaling_schedule" "app_scheduler_up" {
  provider = "aws.client"
  scheduled_action_name  = "app_scheduler_up"
  min_size               = "${var.app_scheduler_up_min_size}"
  max_size               = "${var.app_scheduler_up_max_size}"
  desired_capacity       = "${var.app_scheduler_up_desired_capacity}"
  recurrence             = "${var.app_scheduler_up_recurrence}"
  autoscaling_group_name = "${data.terraform_remote_state.backend.asg_name}"
} 

resource "aws_autoscaling_schedule" "app_scheduler_down" {
  provider = "aws.client"
  scheduled_action_name  = "app_scheduler_down"
   min_size               = "${var.app_scheduler_down_min_size}"
  max_size               = "${var.app_scheduler_down_max_size}"
  desired_capacity       = "${var.app_scheduler_down_desired_capacity}"
  recurrence             = "${var.app_scheduler_down_recurrence}"
  autoscaling_group_name = "${data.terraform_remote_state.backend.asg_name}"
} 
