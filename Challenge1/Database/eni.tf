 module "db_eni"{
  source ="..."
  subnet_id = "${data.aws_subnet.id}"
  security_group = []
  
  tags ={
  name                       = "${var.stack_name}-db-${var.tag_environment}"
  tag_team                   = "${var.tag_team}"
  }
}
