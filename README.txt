

This script install NDN applications on EC2. 


Setup

Set your environment variable for Boto
AWS_ACCESS_KEY_ID:  AWS Access Key ID
AWS_SECRET_ACCESS_KEY:  AWS Secret Access Key
# EC2_KEYPAIR=shak # optional


Example

Run 10 robochat host in us-west-1
./ec2run.py --count 10 --name robochat --region us-west-1


ssh ec2-user@<hostname>


