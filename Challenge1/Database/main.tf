#_______________________________________Database Tier____________________________________________________
#_________________________________Configure Provider Credentials________________
provider "aws"{
  region = var.region
  shared_redentials_file = "~/.aws/credentials"
}

#________________________________Data sources
data "terraform_remote_state" "db_eni" {
}

data "terraform_remote_state" "db_ebs" {
  }
#______________________________________AMI______________________________________

data "aws_ami" "db_win2016" {
  most_recent = true
  filters {
    }
  }

#__________________________________Database Instance_________________________________

module "db_ec2" {
  source = "git:://......."

  count                  = "${var.db_count}"
  ami                    = "${data.ami.id}"
  ins_type               = "${var.db_instance_type}"
  subnet_id              = "${data.aws_subnet.id}"
  user_data              = "${data.templatuserdata_aid}"
  security_groups_ec2_id = ""
  iam_instance_profile   = "${var.db_profile_arn}"
  network_interface_id   = "${data.terraform_remote_state.db_eni.db_eni_id}"

  ebs_optimized     = "${var.ebs_optimized}"
  volume_size       = "${var.root_volume_size}"
  availability_zone = "${var.availability_zone}"

  stack_name = "${var.stack_name}-db"

 tags{
  tag_name =......
     }
#_________________________________EBS Attachment________________________________

module "ebs-system-attach" {
  source = "git,,,,,,,,,,,,,,"

  device_name = "${var.device_n1}"
  volume_id   = "${data.terraform_remote_state.db_ebs.ebs_system_id}"
  instance_id = "${module.db_ec2.custom_instance_id}"
} 
  
#____________________________ENI Attachment______________________________________
 
