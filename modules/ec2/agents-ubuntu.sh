
#Prerequisites:
	#	AWS Account
	#	A running EC2 instance
	#		- with ubuntu OS 
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
  sudo snap install amazon-ssm-agent --classic
  sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
  sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
else
  echo 'SSM agent is already installed.'
fi

# Check if the CloudWatch agent is already installed
if ! command -v amazon-cloudwatch-agent ; then
  echo 'CloudWatch agent not found. Installing...'

  # Create a temporary directory for agent installation
  agent_dir=$(mktemp -d)

  # Download the CloudWatch agent package
  wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -P "$agent_dir"

  # Install the CloudWatch agent package
  sudo dpkg -i "$agent_dir/amazon-cloudwatch-agent.deb"
  sudo apt-get update
  sudo apt-get install -f

  # Define a custom configuration for the CloudWatch agent
  config_file="/opt/aws/amazon-cloudwatch-agent/bin/config.json"
  sudo tee "$config_file" << EOF
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
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c "file:$config_file"

  # Enable the CloudWatch agent to start at system boot
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status

  # Start the CloudWatch agent service
  sudo systemctl start amazon-cloudwatch-agent

  # Clean up the temporary directory
  rm -rf "$agent_dir"
else
  echo 'CloudWatch agent is already installed.'
fi

# Save the contents of config.json to an SSM parameter
config_contents=$(cat "$config_file")
parameter_name="/config-file-ubuntu"
# Check if the SSM parameter already exists
if aws ssm get-parameter --name "$parameter_name" > ; then
  echo "SSM parameter '$parameter_name' already exists. Skipping configuration file storage."
else
  # Store the configuration file in SSM Parameter Store
  aws ssm put-parameter --name "$parameter_name" --value "$config_contents" --type "String" --overwrite
  echo "Config.json saved to SSM parameter: $parameter_name"
fi

echo "Config.json saved to SSM parameter:config-file-ubuntu"

