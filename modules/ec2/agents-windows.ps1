#Prerequisites:
	#	AWS Account
	#	A running EC2 instance
	#		- with Windows os 
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




<powershell>
# Check if SSM Agent is installed
$ssmAgentInstalled = Get-Service "AmazonSSMAgent" -ErrorAction SilentlyContinue
if (!$ssmAgentInstalled) {
  Write-Output "SSM Agent not found. Installing..."

  # Download SSM Agent installer
  Invoke-WebRequest -Uri "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgent.zip" -OutFile "C:\temp\ssm-agent.zip"

  # Extract and install SSM Agent
  Expand-Archive -Path "C:\temp\ssm-agent.zip" -DestinationPath "C:\Program Files\Amazon\SSM"
  Remove-Item "C:\temp\ssm-agent.zip"

  # Start and enable SSM Agent service
  Start-Service -Name "AmazonSSMAgent"
  Set-Service -Name "AmazonSSMAgent" -StartupType Automatic
}
else {
  Write-Output "SSM Agent is already installed."
}

# Check if CloudWatch Agent is installed
$cwAgentInstalled = Get-Command "amazon-cloudwatch-agent" -ErrorAction SilentlyContinue
if (!$cwAgentInstalled) {
  Write-Output "CloudWatch Agent not found. Installing..."

  # Download CloudWatch Agent installer
  $cwAgentZipUrl = "https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip"
  $cwAgentZipPath = "$env:TEMP\AmazonCloudWatchAgent.zip"
  Invoke-WebRequest -Uri $cwAgentZipUrl -OutFile $cwAgentZipPath

  # Extract and install CloudWatch Agent
  Expand-Archive -Path $cwAgentZipPath -DestinationPath 'C:\Program Files\Amazon\AmazonCloudWatchAgent'
  Remove-Item $cwAgentZipPath

  # Run the CloudWatch Agent installer
  Set-Location -Path 'C:\Program Files\Amazon\AmazonCloudWatchAgent'
  .\install.ps1

  # Start CloudWatch Agent service
  Start-Service -Name "AmazonCloudWatchAgent"
}
else {
  Write-Output "CloudWatch Agent is already installed."
}

# CloudWatch Agent configuration
$cwConfigPath = "C:\Program Files\Amazon\AmazonCloudWatchAgent"
$cwConfigFile = "$cwConfigPath\config.json"

# Specify the configuration content for CloudWatch Agent
$cwAgentConfig = @"
{
  "agent": {
    "metrics_collection_interval": 60,
    "logfile": "C:\Program Files\Amazon\AmazonCloudWatchAgent\Logs\amazon-cloudwatch-agent.log"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "C:\Program Files\Amazon\SSM\Logs\amazon-ssm-agent.log",
            "log_group_name": "/my-log-group/ssm-agent-logs",
            "log_stream_name": "{instance_id}-ssm-agent.log",
            "timezone": "UTC"
          }
        ]
      }
    }
  },
  "metrics": {
    "append_dimensions": {
      "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
      "ImageId": "${aws:ImageId}",
      "InstanceId": "${aws:InstanceId}",
      "InstanceType": "${aws:InstanceType}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "*"
        ]
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "*"
        ]
      }
    }
  }
}
"@

# Save the configuration to the file
Set-Content -Path $cwConfigFile -Value $cwAgentConfig -Force
# Set the path of the configuration file
$configFilePath = "C:\Program Files\Amazon\AmazonCloudWatchAgent\config.json"
$parameterName = "/cloudwatch-agent-config"  # Updated parameter name

# Check if the SSM parameter already exists
$existingParameter = Get-SsmParameter -Name $parameterName -ErrorAction SilentlyContinue

if (!$existingParameter) {
  # Read the contents of the configuration file
  $configContent = Get-Content -Path $configFilePath -Raw

  # Store the configuration file in Parameter Store
  Write-SsmParameter -Name $parameterName -Value $configContent -Type SecureString -Overwrite:$true

  Write-Host "Configuration file stored in Parameter Store successfully."
}


# Start CloudWatch Agent
& $Env:ProgramFiles\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1 -m ec2 -a start

# Check CloudWatch Agent status
& $Env:ProgramFiles\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1 -m ec2 -a status

# Start CloudWatch Agent with the configuration file
.\amazon-cloudwatch-agent-ctl.ps1 -a start -m ec2 -c file:'C:\Program Files\Amazon\AmazonCloudWatchAgent\config.json' -s

Write-Output "CloudWatch Agent installed and configured."
</powershell>