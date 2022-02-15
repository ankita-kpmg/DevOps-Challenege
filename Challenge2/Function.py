#Query the instance metadata via instance identity document via link-local address.
#The instance identity document is generated when the instance is launched and it is exposed (in plaintext JSON format) through the Instance Metadata Service. 
#The IP address 169.254.169.254 is a link-local address(and is valid only from the instance).
#AWS gives us link with dedicated Restful API for Retrieving metadata of our running instance.

[ec2-user@ip-172-31-11-129 ~] $ curl http://169.254.169.254/latest/dynamic/instance-identity/document
  {
    "devpayProductCodes" : null,
    "marketplaceProductCodes" : [ "1yguegfieqgghijklm3nopqrs4tu" ], 
    "availabilityZone" : "eu-west-1b",
    "privateIp" : "10.171.117.163",
    "version" : "2018-02-22",
    "instanceId" : "i-9999999999abcdxw1",
    "billingProducts" : null,
    "instanceType" : "t2.micro",
    "accountId" : "123456789012",
    "imageId" : "ami-6ihiewojp01089y",
    "pendingTime" : "2019-10-21T17:30:12Z",
    "architecture" : "x86_64",
    "kernelId" : null,
    "ramdiskId" : null,
    "region" : "eu-west-1"
}

#________Sample Function to retrieve Instance ID _______________________________________
import requests
import sys
import Retry

def get_instance_instanceId():
    instance_identity_url = "http://169.254.169.254/latest/dynamic/instance-identity/document"
    session = requests.Session()
    retries = Retry(total=3, backoff_factor=0.3)
    metadata_adapter = requests.adapters.HTTPAdapter(max_retries=retries)
    session.mount("http://169.254.169.254/", metadata_adapter)
    try:
        r = requests.get(instance_identity_url, timeout=(2, 5))
    except (requests.exceptions.ConnectTimeout, requests.exceptions.ConnectionError) as err:
        print("Sorry! The connection to AWS EC2 Metadata timed out: " + str(err.__class__.__name__))
        print("Is the AWS metadata endpoint blocked? (http://169.254.169.254/)")
        sys.exit(1)
    response_json = r.json()
    instanceID = response_json.get("instanceId")
    return(instanceId)
