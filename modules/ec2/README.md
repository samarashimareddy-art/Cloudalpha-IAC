# AWS EC2 Instance Terraform module
## Introduction
This documentation provides an overview and detailed instructions for working with Amazon Elastic Compute Cloud (EC2) instances. EC2 is a web service that offers resizable compute capacity in the cloud. It allows you to create and manage virtual servers in Amazon's data centers, providing flexibility and scalability for your applications.

## Here are the key about Ec2 Instances
1.	Virtual Servers: EC2 instances are virtual servers in the cloud that can be provisioned and configured to meet specific requirements. Users can choose from a wide range of instance types, each offering different combinations of CPU, memory, storage, and networking capacity.
2.	Scalability: EC2 instances offer flexible scalability, allowing users to easily increase or decrease the number of instances based on demand. This elasticity makes it suitable for applications with varying workloads or unpredictable traffic patterns.
3.	Pricing: EC2 instances are billed based on the usage duration and the instance type chosen. AWS offers various pricing models, including On-Demand instances (pay-as-you-go), Reserved instances (discounted for longer-term commitments), and Spot instances (bid-based pricing).
4.	Operating Systems and Applications: EC2 instances support a wide range of operating systems, including popular options like Linux and Windows. Users can also install and run various applications and services on these instances, making them versatile for different use cases.
5.	Security: EC2 instances provide several security features, including virtual private clouds (VPCs) for network isolation, security groups for controlling inbound and outbound traffic, and the ability to configure access control using AWS Identity and Access Management (IAM).
6.	Availability and Reliability: AWS provides a highly available and reliable infrastructure for EC2 instances. Users can choose to deploy instances across multiple Availability Zones within a region to achieve higher fault tolerance and resilience.
7.	Integration with Other AWS Services: EC2 instances seamlessly integrate with other AWS services, such as Amazon S3 for storage, Amazon RDS for databases, and Amazon VPC for networking, enabling users to build comprehensive and scalable cloud architectures.



## Root Block Device

In Amazon EC2 (Elastic Compute Cloud) instances, the root block device refers to the primary storage device that is attached to an instance and contains the operating system and boot volume. It is also known as the root volume or root EBS (Elastic Block Store) volume.
The root block device is created when you launch an EC2 instance and is typically specified as part of the instance configuration. It can be an EBS volume or an instance store volume, depending on the instance type you choose.
If you choose an EBS-backed instance, the root block device is an EBS volume. EBS volumes provide persistent storage and can be detached from one instance and attached to another, allowing for data portability.
If you choose an instance store-backed instance, the root block device is an instance store volume. Instance store volumes are physically attached to the host machine and provide temporary storage. When the instance is stopped or terminated, the data on the instance store volumes is lost.
When launching an EC2 instance, you can specify the size, type, and other properties of the root block device. You can also create additional block devices and attach them to the instance for additional storage.
It's important to note that the root block device is associated with the instance and is deleted when the instance is terminated, unless you have taken steps to preserve the data (such as creating a snapshot of an EBS volume).


## Ebs_block_device

In Amazon EC2, an EBS block device is a virtual hard disk that can be attached to an EC2 instance. EBS (Elastic Block Store) provides persistent block-level storage volumes for EC2 instances. The ebs_block_device parameter is used when launching an EC2 instance to define the configuration of the EBS volumes attached to the instance.
When creating an EC2 instance, you can specify one or more EBS block devices using the BlockDeviceMappings parameter. Each block device mapping consists of several properties, including the DeviceName, Ebs, and NoDevice.

##Ephermal block device
An ephemeral block device in Amazon EC2 refers to a temporary storage volume that is physically attached to the host machine, which provides storage for the EC2 instance. These devices are also referred to as instance store volumes.

An ephemeral block device in EC2 is useful for temporary storage needs where data persistence is not required, and fast access to data is important. It is best suited for cache or session storage in high-performance applications, but because the data is lost on instance stop or termination, it is not appropriate for storing critical or long-term data.


## Network Interface
In an Amazon EC2 (Elastic Compute Cloud) instance, a network interface represents a virtual network card that connects the instance to a network. It enables communication between the instance and other resources in the network, such as other instances, load balancers, or external services.
Every EC2 instance is associated with one or more network interfaces, depending on its configuration. The primary network interface is created automatically when you launch an instance and is assigned a private IP address. You can also attach additional network interfaces to an instance, each with its own private IP address.

# Ec2 module to install SSM Agent and CloudWatch Agent,Aws_inspector 

## For Linux instances 
### SSM Agent
•	The Systems Manager Agent (SSM Agent) allows you to manage and automate EC2 instances at scale.

•	It provides a secure channel for communication between your EC2 instances and the Systems Manager service.

•	With SSM Agent, you can perform tasks such as remote command execution, software installations, and patch management.

•	Installation Command: 

    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

•	Start Command: sudo systemctl start amazon-ssm-agent

•	Enable Command: sudo systemctl enable amazon-ssm-agent


### CloudWatch Agent
•	The CloudWatch Agent enables detailed monitoring and collection of system-level and application-level metrics.

•	It provides insights into resource utilization, application performance, and logs from your EC2 instances.

•	CloudWatch Agent allows you to create custom metrics, dashboards, and alarms for effective monitoring.

•	Installation Command:

    sudo yum install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm

•	Start Command: sudo systemctl start amazon-cloudwatch-agent

•	Enable Command: sudo systemctl enable amazon-cloudwatch-agent


### AWS Inspector Agent 
•	The AWS Inspector Agent performs security assessments on your EC2 instances to identify vulnerabilities and deviations from security best practices.

•	It helps you evaluate the security posture of your applications and infrastructure.

•	AWS Inspector provides detailed findings and recommendations to assist in remediating security issues.

•	Installation Command:

    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

•	Start Command: 

     sudo systemctl start amazon-ssm-agent

•	Enable Command: sudo systemctl enable amazon-ssm-agent


## Windows Instances 

### SSM Agent Overview:
•	The Systems Manager Agent (SSM Agent) allows you to manage and automate EC2 instances at scale.

•	It provides a secure channel for communication between your EC2 instances and the Systems Manager service.

•	With SSM Agent, you can perform tasks such as remote command execution, software installations, and patch management.

•	Installation and Configuration:

	Download Command: Invoke-WebRequest "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe" -OutFile "C:\temp\AmazonSSMAgentSetup.exe"

•	Installation Command: 
   
    Start-Process "C:\temp\AmazonSSMAgentSetup.exe" -ArgumentList 

•	"/install /quiet" -Wait`

### CloudWatch Agent Overview:
•	The CloudWatch Agent enables detailed monitoring and collection of system-level and application-level metrics.

•	It provides insights into resource utilization, application performance, and logs from your EC2 instances.

•	CloudWatch Agent allows you to create custom metrics, dashboards, and alarms for effective monitoring.

•	Installation and Configuration:

    Download Command: Invoke-WebRequest "https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/amazon-cloudwatch-agent.msi" -OutFile "C:\temp\amazon-cloudwatch-agent.msi"

•	Installation Command:

    Start-Process "msiexec.exe" -ArgumentList "/i C:\temp\amazon-cloudwatch-agent.msi /quiet" -Wait


### AWS Inspector Agent Overview:
•	The AWS Inspector Agent performs security assessments on your EC2 instances to identify vulnerabilities and deviations from security best practices.

•	It helps you evaluate the security posture of your applications and infrastructure.

•	AWS Inspector provides detailed findings and recommendations to assist in remediating security issues.

•	Installation and Configuration:

•	Download Command:

    Invoke-WebRequest "https://inspector-agent.amazonaws.com/windows/installer/latest/AWSAgentInstall.exe" -OutFile "C:\temp\AWSAgentInstall.exe"

•	Installation Command: 

    Start-Process "C:\temp\AWSAgentInstall.exe" -ArgumentList "/install /quiet" -Wait

•	The -ArgumentList parameter provides additional arguments to the installer.
•	/install instructs the installer to perform the installation.
•	/quiet makes the installation process run silently without displaying any prompts.
•	-Wait ensures that the script waits for the installation to complete before proceeding.
•	This line uses Invoke-WebRequest cmdlet to download the SSM Agent installer from the specified URL.
•	The -OutFile parameter specifies the location where the downloaded file will be saved.



## MAC OS

### SSM Agent Overview:
•	The Systems Manager Agent (SSM Agent) allows you to manage and automate macOS machines at scale.

•	It provides a secure channel for communication between your macOS machines and the Systems Manager service.

•	With SSM Agent, you can perform tasks such as remote command execution, software installations, and patch management.

•	Installation and Configuration:

•	Download Command: 

    curl "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/mac/amazon-ssm-agent.pkg" -o "amazon-ssm-agent.pkg"

•	Installation Command:

     sudo installer -pkg amazon-ssm-agent.pkg -target /`

### CloudWatch Agent Overview:
•	The CloudWatch Agent enables detailed monitoring and collection of system-level and application-level metrics.

•	It provides insights into resource utilization, application performance, and logs from your macOS machines.

•	CloudWatch Agent allows you to create custom metrics, dashboards, and alarms for effective monitoring.

•	Installation and Configuration:

•	Download Command: 

    curl https://s3.amazonaws.com/amazoncloudwatch-agent/mac/latest/amazon-cloudwatch-agent.pkg -O

•	Installation Command: 

    sudo installer -pkg amazon-cloudwatch-agent.pkg -target /`

•	This command uses installer with sudo to install the CloudWatch Agent package.

•	The -pkg option specifies the package file to be installed.

•	The -target option indicates the target volume where the package will be installed, in this case, the root ("/").


### AWS Inspector Agent Overview:
•	The AWS Inspector Agent performs security assessments on your macOS machines to identify vulnerabilities and deviations from security best practices.

•	It helps you evaluate the security posture of your applications and infrastructure.

•	AWS Inspector provides detailed findings and recommendations to assist in remediating security issues.

•	Installation and Configuration:

•	Download Command: 

    curl -O https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install

•	Change Permissions Command: 

    chmod +x install

•	Installation Command: 

    sudo ./install

•	curl to download the AWS Inspector Agent installer.

•	The -O option saves the downloaded file with the same name as the remote file.

•	The second line grants execute permissions to the installer script using chmod.

•	The third line executes the installer script with administrative privileges using sudo ./install.



### Conclusion:
•	By installing and configuring these agents, you gain powerful capabilities for managing, monitoring, and securing your macOS machines.

•	The SSM Agent enables efficient management and automation.

•	The CloudWatch Agent provides comprehensive monitoring and metrics.

•	The AWS Inspector Agent helps assess and improve the security of your infrastructure.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.16.1 |
| <a name="requirement_terragrunt"></a> [aws](#requirement\_terragrunt) | >= 0.15.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.16.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.ignore_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_spot_instance_request.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | ID of AMI to use for the instance | `string` | `null` | no |
| <a name="input_ami_ssm_parameter"></a> [ami\_ssm\_parameter](#input\_ami\_ssm\_parameter) | SSM parameter name for the AMI ID. For Amazon Linux AMI SSM parameters see [reference](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html) | `string` | `"/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IP address with an instance in a VPC | `bool` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ to start the instance in | `string` | `null` | no |
| <a name="input_capacity_reservation_specification"></a> [capacity\_reservation\_specification](#input\_capacity\_reservation\_specification) | Describes an instance's Capacity Reservation targeting option | `any` | `{}` | no |
| <a name="input_cpu_credits"></a> [cpu\_credits](#input\_cpu\_credits) | The credit option for CPU usage (unlimited or standard) | `string` | `null` | no |
| <a name="input_cpu_options"></a> [cpu\_options](#input\_cpu\_options) | Defines CPU options to apply to the instance at launch time. | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create an instance | `bool` | `true` | no |
| <a name="input_create_iam_instance_profile"></a> [create\_iam\_instance\_profile](#input\_create\_iam\_instance\_profile) | Determines whether an IAM instance profile is created or to use an existing IAM instance profile | `bool` | `false` | no |
| <a name="input_create_spot_instance"></a> [create\_spot\_instance](#input\_create\_spot\_instance) | Depicts if the instance is a spot instance | `bool` | `false` | no |
| <a name="input_disable_api_stop"></a> [disable\_api\_stop](#input\_disable\_api\_stop) | If true, enables EC2 Instance Stop Protection | `bool` | `null` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | If true, enables EC2 Instance Termination Protection | `bool` | `null` | no |
| <a name="input_ebs_block_device"></a> [ebs\_block\_device](#input\_ebs\_block\_device) | Additional EBS block devices to attach to the instance | `list(any)` | `[]` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `null` | no |
| <a name="input_enable_volume_tags"></a> [enable\_volume\_tags](#input\_enable\_volume\_tags) | Whether to enable volume tags (if enabled it conflicts with root\_block\_device tags) | `bool` | `true` | no |
| <a name="input_enclave_options_enabled"></a> [enclave\_options\_enabled](#input\_enclave\_options\_enabled) | Whether Nitro Enclaves will be enabled on the instance. Defaults to `false` | `bool` | `null` | no |
| <a name="input_ephemeral_block_device"></a> [ephemeral\_block\_device](#input\_ephemeral\_block\_device) | Customize Ephemeral (also known as Instance Store) volumes on the instance | `list(map(string))` | `[]` | no |
| <a name="input_get_password_data"></a> [get\_password\_data](#input\_get\_password\_data) | If true, wait for password data to become available and retrieve it | `bool` | `null` | no |
| <a name="input_hibernation"></a> [hibernation](#input\_hibernation) | If true, the launched EC2 instance will support hibernation | `bool` | `null` | no |
| <a name="input_host_id"></a> [host\_id](#input\_host\_id) | ID of a dedicated host that the instance will be assigned to. Use when an instance is to be launched on a specific dedicated host | `string` | `null` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile | `string` | `null` | no |
| <a name="input_iam_role_description"></a> [iam\_role\_description](#input\_iam\_role\_description) | Description of the role | `string` | `null` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name to use on IAM role created | `string` | `null` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | IAM role path | `string` | `null` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the IAM role | `string` | `null` | no |
| <a name="input_iam_role_policies"></a> [iam\_role\_policies](#input\_iam\_role\_policies) | Policies attached to the IAM role | `map(string)` | `{}` | no |
| <a name="input_iam_role_tags"></a> [iam\_role\_tags](#input\_iam\_role\_tags) | A map of additional tags to add to the IAM role/profile created | `map(string)` | `{}` | no |
| <a name="input_iam_role_use_name_prefix"></a> [iam\_role\_use\_name\_prefix](#input\_iam\_role\_use\_name\_prefix) | Determines whether the IAM role name (`iam_role_name` or `name`) is used as a prefix | `bool` | `true` | no |
| <a name="input_ignore_ami_changes"></a> [ignore\_ami\_changes](#input\_ignore\_ami\_changes) | Whether changes to the AMI ID changes should be ignored by Terraform. Note - changing this value will result in the replacement of the instance | `bool` | `false` | no |
| <a name="input_instance_initiated_shutdown_behavior"></a> [instance\_initiated\_shutdown\_behavior](#input\_instance\_initiated\_shutdown\_behavior) | Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instance | `string` | `null` | no |
| <a name="input_instance_tags"></a> [instance\_tags](#input\_instance\_tags) | Additional tags for the instance | `map(string)` | `{}` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to start | `string` | `"t3.micro"` | no |
| <a name="input_ipv6_address_count"></a> [ipv6\_address\_count](#input\_ipv6\_address\_count) | A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet | `number` | `null` | no |
| <a name="input_ipv6_addresses"></a> [ipv6\_addresses](#input\_ipv6\_addresses) | Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface | `list(string)` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource | `string` | `null` | no |
| <a name="input_launch_template"></a> [launch\_template](#input\_launch\_template) | Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template | `map(string)` | `{}` | no |
| <a name="input_maintenance_options"></a> [maintenance\_options](#input\_maintenance\_options) | The maintenance options for the instance | `any` | `{}` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | Customize the metadata options of the instance | `map(string)` | <pre>{<br>  "http_endpoint": "enabled",<br>  "http_put_response_hop_limit": 1,<br>  "http_tokens": "optional"<br>}</pre> | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | If true, the launched EC2 instance will have detailed monitoring enabled | `bool` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on EC2 instance created | `string` | `""` | no |
| <a name="input_network_interface"></a> [network\_interface](#input\_network\_interface) | Customize network interfaces to be attached at instance boot time | `list(map(string))` | `[]` | no |
| <a name="input_placement_group"></a> [placement\_group](#input\_placement\_group) | The Placement Group to start the instance in | `string` | `null` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | Private IP address to associate with the instance in a VPC | `string` | `null` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Customize details about the root block device of the instance. See Block Devices below for details | `list(any)` | `[]` | no |
| <a name="input_secondary_private_ips"></a> [secondary\_private\_ips](#input\_secondary\_private\_ips) | A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a `network_interface block` | `list(string)` | `null` | no |
| <a name="input_source_dest_check"></a> [source\_dest\_check](#input\_source\_dest\_check) | Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs | `bool` | `null` | no |
| <a name="input_spot_block_duration_minutes"></a> [spot\_block\_duration\_minutes](#input\_spot\_block\_duration\_minutes) | The required duration for the Spot instances, in minutes. This value must be a multiple of 60 (60, 120, 180, 240, 300, or 360) | `number` | `null` | no |
| <a name="input_spot_instance_interruption_behavior"></a> [spot\_instance\_interruption\_behavior](#input\_spot\_instance\_interruption\_behavior) | Indicates Spot instance behavior when it is interrupted. Valid values are `terminate`, `stop`, or `hibernate` | `string` | `null` | no |
| <a name="input_spot_launch_group"></a> [spot\_launch\_group](#input\_spot\_launch\_group) | A launch group is a group of spot instances that launch together and terminate together. If left empty instances are launched and terminated individually | `string` | `null` | no |
| <a name="input_spot_price"></a> [spot\_price](#input\_spot\_price) | The maximum price to request on the spot market. Defaults to on-demand price | `string` | `null` | no |
| <a name="input_spot_type"></a> [spot\_type](#input\_spot\_type) | If set to one-time, after the instance is terminated, the spot request will be closed. Default `persistent` | `string` | `null` | no |
| <a name="input_spot_valid_from"></a> [spot\_valid\_from](#input\_spot\_valid\_from) | The start date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ) | `string` | `null` | no |
| <a name="input_spot_valid_until"></a> [spot\_valid\_until](#input\_spot\_valid\_until) | The end date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ) | `string` | `null` | no |
| <a name="input_spot_wait_for_fulfillment"></a> [spot\_wait\_for\_fulfillment](#input\_spot\_wait\_for\_fulfillment) | If set, Terraform will wait for the Spot Request to be fulfilled, and will throw an error if the timeout of 10m is reached | `bool` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID to launch in | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_tenancy"></a> [tenancy](#input\_tenancy) | The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host | `string` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting EC2 instance resources | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user\_data\_base64 instead | `string` | `null` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | Can be used instead of user\_data to pass base64-encoded binary data directly. Use this instead of user\_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption | `string` | `null` | no |
| <a name="input_user_data_replace_on_change"></a> [user\_data\_replace\_on\_change](#input\_user\_data\_replace\_on\_change) | When used in combination with user\_data or user\_data\_base64 will trigger a destroy and recreate when set to true. Defaults to false if not set | `bool` | `null` | no |
| <a name="input_volume_tags"></a> [volume\_tags](#input\_volume\_tags) | A mapping of tags to assign to the devices created by the instance at launch time | `map(string)` | `{}` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami"></a> [ami](#output\_ami) | AMI ID that was used to create the instance |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the instance |
| <a name="output_capacity_reservation_specification"></a> [capacity\_reservation\_specification](#output\_capacity\_reservation\_specification) | Capacity reservation specification of the instance |
| <a name="output_ebs_block_device"></a> [ebs\_block\_device](#output\_ebs\_block\_device) | EBS block device information |
| <a name="output_ephemeral_block_device"></a> [ephemeral\_block\_device](#output\_ephemeral\_block\_device) | Ephemeral block device information |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | ARN assigned by AWS to the instance profile |
| <a name="output_iam_instance_profile_id"></a> [iam\_instance\_profile\_id](#output\_iam\_instance\_profile\_id) | Instance profile's ID |
| <a name="output_iam_instance_profile_unique"></a> [iam\_instance\_profile\_unique](#output\_iam\_instance\_profile\_unique) | Stable and unique string identifying the IAM instance profile |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | The name of the IAM role |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
| <a name="output_id"></a> [id](#output\_id) | The ID of the instance |
| <a name="output_instance_state"></a> [instance\_state](#output\_instance\_state) | The state of the instance |
| <a name="output_ipv6_addresses"></a> [ipv6\_addresses](#output\_ipv6\_addresses) | The IPv6 address assigned to the instance, if applicable |
| <a name="output_outpost_arn"></a> [outpost\_arn](#output\_outpost\_arn) | The ARN of the Outpost the instance is assigned to |
| <a name="output_password_data"></a> [password\_data](#output\_password\_data) | Base-64 encoded encrypted password data for the instance. Useful for getting the administrator password for instances running Microsoft Windows. This attribute is only exported if `get_password_data` is true |
| <a name="output_primary_network_interface_id"></a> [primary\_network\_interface\_id](#output\_primary\_network\_interface\_id) | The ID of the instance's primary network interface |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | The private IP address assigned to the instance |
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws\_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached |
| <a name="output_root_block_device"></a> [root\_block\_device](#output\_root\_block\_device) | Root block device information |
| <a name="output_spot_bid_status"></a> [spot\_bid\_status](#output\_spot\_bid\_status) | The current bid status of the Spot Instance Request |
| <a name="output_spot_instance_id"></a> [spot\_instance\_id](#output\_spot\_instance\_id) | The Instance ID (if any) that is currently fulfilling the Spot Instance request |
| <a name="output_spot_request_state"></a> [spot\_request\_state](#output\_spot\_request\_state) | The current request state of the Spot Instance Request |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
