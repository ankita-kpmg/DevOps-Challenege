#___________________Variable definitions for any Demo Environment to be built______________________
aws_management_account = "222222222222"
aws_client_account = "111111111111"
availability_zone = "us-east-1a"
vpc_name = "clientvpc"
vpc_id = "vpc-ofeigfewifhewiuuhqf"
account_type = "nonprod"
subnet = "subnet-1"
db_count = "2"
db_eni = "db_eni"
db_ebs = "db_ebs"
db_sg = "db_sg"
#___________________________Tags_______________________________
environment_tag = "dev"
team_tag = "team_one"
#____________________________KMS_______________________________
kms_deployer_arn = "arn:aws:iam::us-east-1a-----------"
#____________________AMIS_____________________
web_ami = "web"
app_ami = "app"
db_ami = "db"
#________________Userdata____________________
sql_url = "https://pre-dev/service/local/repo/IND/SQL/SQL-developer.iso "
web_zip = "https://web/artifactory/web.zip"
app_location = "https://app/artifactory/app.ear"
#_______________S3_________________________________________
project_folder_bucket ="MY_APP"
db_bucket = "my-app-db"
logs_bucket = "my-app-logs"
bucket acl = "private"
#__________________DB____________________________
hostname = "EXUFHGEIFO1"
#_______________VAULT_____________
vault_addr = "https://my-vault.com"
vault_web_role = "my-app-web"
vault_app_role = "my-app-app"

#______________SG Configurations_____________
#________Ports______
port_80 = "80"
port_8080 = "8080"
port_3912 = "3912"
port_3175 = "3175"
port_1415 = "1415" 
port_3175 ="3175"
port_3126 ="3126"
#_____________SGS___
#_______SG IDs___
sg_vault = "sg-78460y"
sg_db_jenkins="sg-hihf6e"
sg_artifactory="sg-87yq28"
#____CIDR__________
cidr_des="10.0.0.1/16,---"
cidr_app="10.1.0.0/16,---"
cidr_app_dr=""
cidr_med=""
cidr_ext=""
cidr_dev=""
cidr_db_serv=""
cidr_db_serv_dr=""
#_________Shared SG config_______
#_____shared web to app internal alb sg______
web_to_App_alb_shared_sg ="dev-shared-web-to-app-alb-sg"
shared_sg_tag_role="shared-web-to-app-alb-sg"
#_______shared web to db sg_______
web_to_db_sg_name ="dev-shared-web-to-db-sg"
shared_sg_db_tag_role= "shared-web-to-db-sg"
#_______shared web alb to web asg sg___
web_alb_to_web_asg_sg = "dev-shared-web-alb-to-web-asg_sg"
web_alb_to_web_asg_sg_description = "Web ALB And Web ASG Circular Dependency Management."
web_alb_to_web_asg_sg_tag_role = "dev-shared-web-alb-to-web-asg_sg"
#____________Shared App ALB To App ASG Security Group
app_alb_to_app_asg_sg = "dev-shared-app-alb-to-app-asg_sg"
app_alb_to_app_asg_sg_description = "App ALB And App ASG Circular Dependency Management."
app_alb_to_app_asg_sg_tag_role = "dev-shared-app-alb-to-app-asg-sg"
#_________shared mirror db sg______________
db_mirroring_sg_name = "dev-shared-db-mirroring-sg"
db_mirroring_sg_description = "DB Mirroring Security Group"
db_mirroring_sg_tag_role = "dev-shared-db-mirroring-sg"
#______________________Web & ALB security Group Configuration___________________
#___________Web ALB Security Group
web_alb_sg_name = "web-alb-sg"
web_alb_sg_description = "Web ALB External Dependecy Connectivity."
web_alb_sg_tag_role = "dev-web-alb-sg" 
#___________Web Security Group
web_sg_name = "web-sg"
web_sg_description = "Web ASG External Dependecy Connectivity."
web_sg_tag_role = "dev-web-sg"
#______________________App & ALB Security Group Configuration___________________
#___________App ALB General Security Group
app_alb_sg_name = "app-alb-sg"
app_alb_sg_description = "App ALB External Dependecy Connectivity."
app_alb_sg_tag_role = "dev-app-alb-sg"
#___________App Security Group
app_sg_name = "app-sg"
app_sg_description = "App ASG external Dependecy Connectivity."
app_sg_tag_role = "dev-app-sg" 
#__________________________DB SG Config______________________
db_sg_name = "db-sg"
db_sg_description = "DB External Dependecy Connectivity."
db_sg_tag_role = "dev_db_sg"
db_sg = "db_sg"
#______________________________Web ALB Config____________________________
#____Web ALB Target Group General
alb_is_internal = true
tg_deregistration_delay = "300"
tg_cookie_duration = "86400"
tg_enable_stickiness = true
#____Web ALB Target Group Health Check
tg_healthy_threshold = "3"
tg_unhealthy_threshold = "8" 
tg_healthy_threshold_internal = "5"
tg_unhealthy_threshold_internal = "5"
tg_check_timeout = "30"
tg_check_interval = "60"
#____Web ALB Target Group
service_int_name = "internal"
tg_internal_health_check_path = "/myappbrowser"
#____Web ALB Listener
web_listener_ssl_policy = "ELBSecurityPolicy-2015-01"
web_listener_certificate_arn = "arn:aws:acm:----------"
idle_timeout = "300"
#____Web ALB Listener Rules
priority_internal = "2"
listener_rule_field = "header-pattern"
listener_rule_values_internal = "web-dev-alb.aws-useast1-np.myapp.com"
#_______________________________Web ASG VarS_______________________________
web_instance_type = "t3.medium"
web_profile_arn = "myapp-web-a872eec50000"
web_asg_namespace = "AWS/EC2"
asg_web_name = "myapp-web-dev"
web_az_count = "2"
web_asg_max_child = "3"
web_asg_min_child = "2"
web_health_check_grace_period = "600"
web_health_check_type = "ELB"
web_asg_evaluation_periods_so = "4"
web_asg_evaluation_periods_si = "10"
web_asg_period_so = "120"
web_asg_period_si = "60"
web_asg_threshold_so = "80"
web_asg_threshold_si = "20"
web_asg_metric_name = "CPUUtilization"
web_asg_statistic = "Average"
#______________________________Web ASG Scheduler Var____________________________
web_scheduler_up_min_size = "2"
web_scheduler_up_max_size = "3"
web_scheduler_up_desired_capacity = "2"
web_scheduler_up_recurrence = "00 2 * * 1-5"
web_scheduler_down_min_size = "0"
web_scheduler_down_max_size = "0"
web_scheduler_down_desired_capacity = "0"
web_scheduler_down_recurrence = "00 18 * * *" 
#______________________________App ALB Configuration____________________________
#____App LB Target Group
app_tg_deregistration_delay = "60"
app_tg_cookie_duration = "86400"
app_tg_enable_stickiness = true
app_alb_is_internal = true
app_tg_9982_check_path = "/myapp/"
app_tg_healthy_threshold = "2"
app_tg_unhealthy_threshold = "10"
app_tg_check_timeout = "60"
app_tg_check_interval = "61"
app_service_name_9982 = "myapp9982-1"
#____App LB Listener
app_listener_ssl_policy = "ELBSecurityPolicy-2015-03"
app_listener_certificate_arn = "arn:aws:acm:---------------"
#____Application Load Balancer Listener Rules
app_priority = "2"
app_listener_rule_field = "path-header"
app_listener_rule_values_9443 = "/myapp"
#_______________________________App ASG Variables_______________________________
app_instance_type = "t3.medium"
app_profile_arn = "myapp-1cafuuuuuuf344"
app_profile_name = "myapp-00yyyyyed3f4"
app_asg_namespace = "AWS/EC2"
asg_app_name = "asg-app-dev" 
app_az_count = "2"
app_asg_max_child = "3"
app_asg_min_child = "2"
app_ebs_optimized = "false"
app_volume_size = "50"
app_trend_policy_id = "21"
app_health_check_grace_period = "1200"
app_health_check_type = "ELB"
app_asg_evaluation_periods_so = "4"
app_asg_evaluation_periods_si = "10"
app_asg_period_so = "120"
app_asg_period_si = "60"
app_asg_threshold_so = "80"
app_asg_threshold_si = "20"
app_asg_metric_name = "CPUUtilization"
app_asg_statistic = "Average" 
#______________________________App ASG Scheduler Vars____________________________
app_scheduler_up_min_size = "2"
app_scheduler_up_max_size = "3"
app_scheduler_up_desired_capacity = "2"
app_scheduler_up_recurrence = "00 2 * * 1-5"
app_scheduler_down_min_size = "0"
app_scheduler_down_max_size = "0"
app_scheduler_down_desired_capacity = "0"
app_scheduler_down_recurrence = "00 18 * * *" 
#______________________________DB Instance Vars____________________________
#____________________EC2 GenConfig__________
db_instance_type = "m4.xlarge"
db_profile_arn = "db-o000007bee8u6"
db_tag_PatchStrategy = "in-place"
db_tag_role = "db_server"
db_count = "1"
#____________________EC2 EBS Volumes
ebs_optimized = "true"
device_name1 = "xbbb"
device_name2 = "xyyy"
device_name3 = "xiii"
device_name4 = "xxxx"
root_volume_size = "90"
system_volume_size = "40"
data_volume_size = "60"
backup_volume_size = "90"
tempdb_volume_size = "50"
storage_type = "gp2"
#___________________________________DNS Variables_______________________________
hosted_zone_id = "YG2Y77BHDKCD"
hosted_zone = "myapp.aws-use1-np.myapp.com"
web_service_record_name = "web-dev-alb"
service_record_name_app = "app-dev-alb"
db_service_record_name = "db" 
#_______________________________Cloudwatch Variables____________________________
sns_topic_info = ""
sns_topic_alert = ""
sns_topic_db_info = ""
sns_topic_db_alert = "" 
#______________________________DB Cloudwatch Variables
cpu_threshold_info = "75"
cpu_threshold_action = "85"
cpu_period = "300"
memory_threshold_info = "75"
memory_threshold_action = "85"
memory_period = "300"
diskspace_threshold = "20"
diskspace_period = "300"
inst_status_period = "1200"
ebs_mounpoints_diskspace_threshold = "20"
