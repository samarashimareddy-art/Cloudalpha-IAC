

#!/bin/bash

# Check if the CloudWatch agent is already installed
if ! command -v amazon-cloudwatch-agent ; then
  echo 'CloudWatch agent not found. Installing...'

  # Create a temporary directory for agent installation
  agent_dir=$(mktemp -d)

  # Download the CloudWatch agent package
  curl -o "$agent_dir/amazon-cloudwatch-agent.pkg" https://s3.amazonaws.com/amazoncloudwatch-agent/macos/latest/amazon-cloudwatch-agent.pkg

  # Install the CloudWatch agent package
  sudo installer -pkg "$agent_dir/amazon-cloudwatch-agent.pkg" -target /

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
            "file_path": "/var/log/system.log",
            "log_group_name": "SyslogLogGroup",
            "log_stream_name": "{instance_id}_system.log"
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
  sudo launchctl load /Library/LaunchDaemons/com.amazon.cloudwatch.agent.plist

  # Clean up the temporary directory
  rm -rf "$agent_dir"
else
  echo 'CloudWatch agent is already installed.'
fi
