
	#Prerequisites:
	#	AWS Account
	#	A running EC2 instance
	#		- with Linux OS 
	#	1. Create the IAM role.
	#	2. Attach IAM role to the instance.
	#	3. Download the CloudWatch agent on the EC2 instance.
	#	4. Create the CloudWatch agent configuration file.
	#	5. Start the CloudWatch agent.
	#	6. Verify the CloudWatch agent is sending information to CloudWatch.

# Create and attach the IAM role
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent.html
# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/iam-roles-for-amazon-ec2.html#attach-iam-role

# Download and install the SSM agent and CloudWatch Agent on the EC2 instance
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-EC2-Instance.html


#!/bin/bash

# Check if the SSM agent is already installed
if ! command -v amazon-ssm-agent ; then
  echo 'SSM agent not found. Installing...'
  sudo yum install -y amazon-ssm-agent
  sudo systemctl start amazon-ssm-agent
  sudo systemctl enable amazon-ssm-agent
else
  echo 'SSM agent is already installed.'
fi

# Check if the CloudWatch agent is already installed
if ! command -v amazon-cloudwatch-agent ; then
  echo 'CloudWatch agent not found. Installing...'

  # Create a temporary directory for agent installation
  agent_dir=$(mktemp -d)

  # Download the CloudWatch agent package
  wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm -P "$agent_dir"

  # Install the CloudWatch agent package
  sudo rpm -U "$agent_dir/amazon-cloudwatch-agent.rpm"

  # Define a custom configuration for the CloudWatch agent
  sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json  << EOF
{
  "agent": {
    "run_as_user": "root"
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "\${aws:InstanceId}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "resources": [
          "/"
        ],
        "measurement": [
          "used_percent",
          "inodes_free"
        ],
        "metrics_collection_interval": 300
      },
      "mem": {
        "measurement": [
          "mem_used_percent",
          "mem_available_percent"
        ],
        "metrics_collection_interval": 60
      },
      "swap": {
        "measurement": [
          "swap_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "SyslogLogGroup",
            "log_stream_name": "{instance_id}_syslog"
          }
        ]
      }
    }
  }
}
EOF

  # Start the CloudWatch agent with the custom configuration
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

  # Enable the CloudWatch agent to start at system boot
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status

  # Start the CloudWatch agent service
  sudo systemctl start amazon-cloudwatch-agent

  # Clean up the temporary directory
  rm -rf "$agent_dir"
else
  echo 'CloudWatch agent is already installed.'
fi

# Retrieve SSM parameter
my_parameter_value=$(aws ssm get-parameter --name "\cloud-watch-agent-linux" --query "Parameter.Value" --output text)

# Check if the parameter value is empty
if [ -z "$my_parameter_value" ]; then
  echo "SSM parameter doesnot exist. Creating..."
  # Save configuration file as SSM parameter
  aws ssm put-parameter --name "\cloud-watch-agent-linux" --value "$(cat /opt/aws/amazon-cloudwatch-agent/bin/config.json)" --type "String" --overwrite
else
  echo "SSM parameter already exists."
fi

