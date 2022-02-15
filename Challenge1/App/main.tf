#_______________________________________Application Tier____________________________________________________
#_________________________________Configure Provider Credentials________________
provider "aws"{
  region = var.region
  shared_redentials_file = "~/.aws/credentials"
}

#______________________________________AMI______________________________________

data "aws_ami" "app_ami" {
  most_recent = true
  filter {
    name   = "tag:Name"
    values = ["${var.app_ami_name}"]
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
    vault_app_role          = "${var.vault_app_role}"
    domain_join_user        = "${var.domain_join_user}"
    domain_join_password    = "${var.domain_join_password}"
    ou_path                 = "${var.app_ou_path}"
    myappear_location       = "${var.myappear_location}"
    asg_name                = "${var.asg_app_name}"
    logs_bucket_name        = "${var.logs_bucket_name}"
    no_proxy                = "${var.no_proxy}"
    admin_group      = "${var.admin_group}"
    developer_group  = "${var.developer_group}"
  }
}

#________________App EC2 Instances___________________________
resource "aws_instance" "appserver1" {
  ami                    = "ami-0d5eff06f840b66p3"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.appserver-sg.id]
  subnet_id              = aws_subnet.app-subnet-1.id
  user_data              = file("install_apache.sh")

  tags = {
    Name = "App Server"
  }
}

resource "aws_instance" "appserver2" {
  ami                    = "ami-0d5eff06f840b66p3"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1b"
  vpc_security_group_ids = [aws_security_group.appserver-sg.id]
  subnet_id              = aws_subnet.app-subnet-2.id
  user_data              = file("install_apache.sh")

  tags = {
    Name = "App Server"
  }
}

#____________________________Application load balancer_________________________

resource "aws_lb" "app_alb" {
  provider = "aws.client"
  security_groups            =  [""
  ]
  subnets                    = ["${data.aws_subnet.*.id}"]
  load_balancer_type         = "application"
  internal                   =  true
  name                       = "${var.stack_name}-app-ALB-${var.tag_environment}"
  idle_timeout               = "${var.idle_timeout}" 
   tags {
   Name                       = "${var.stack_name}-app-ALB-${var.tag_environment}"
   tag_environment            = "${var.tag_environment}"
   team                       = "${var.tag_team}"
 }
} 

resource "aws_lb_target_group" "app_tg" {
  provider ="aws.client"
  vpc_id   = "${var.vpc_id}" 
  name                       = "${var.stack_name}-app-ALB-TG-${var.tag_environment}"
  port                       = "${var.port_7070}"                
  protocol                   = "${var.protocol_http}"
  deregistration_delay       = "${var.app_tg_deregistration_delay}"
  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = "${var.app_tg_cookie_duration}"
  }

  health_check {
    interval            = "${var.app_tg_check_interval}"
    path                = ""
    timeout             = ""
    healthy_threshold   = "${var.app_tg_healthy_threshold}"
    unhealthy_threshold = "${var.app_tg_unhealthy_threshold}"
    matcher             = ""
  }
  tags {
.....
  }
}  
 
resource "aws_lb_listener" "app_alb_listener" {
  provider = "aws.client"
  load_balancer_arn = "${aws_lb.app_alb.arn}"
  protocol          = "HTTPS"
  port            = "${var.port_cccc}"
  ssl_policy      = "${var.listener_ssl_policy}"
  certificate_arn = "${var.listener_certificate_arn}"
  default_action {
    target_group_arn = "${aws_lb_target_group.app_tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "app_alb_listener_rule" {
  
  provider = "aws.client"

  listener_arn     = "${aws_lb_listener.app_alb_listener.arn}"
  priority         = "${var.app_priority_9999}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.app_tg.arn}"
  }
  condition {
    field  = "${var.app_listener_rule_field}"
    values = ["${var.app_listener_rule_values}"]
  }
} 
 
#_________________________ASG_________________________________
resource "aws_autoscaling_group" "asg" {
  asg_app_name = "asg-app-dev" 
  # ... other configuration ...

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  elb                    = aws_elb.test.id
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
