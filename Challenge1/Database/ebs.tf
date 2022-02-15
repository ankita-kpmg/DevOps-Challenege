#___________________________________EBS Volume__________________________________

module "ebs-system" {
  source = "git::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

  volume_size                = "${var.system_volume_size}"
  storage_type               = "${var.storage_type}"
  availability_zone          = "${var.availability_zone}"
  kms_key                    = "${data.terraform_remote_state.shared_kms.cmk}"
  stack_name                 = "${var.stack_name}-system"
tags{
  ...........
    }
  }
