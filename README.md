EC2run
=======
This script installs NDN applications on EC2. 


Installation
------------
Install Boto.

    git clone https://github.com/boto/boto.git
    cd boto
    python setup.py install

Set environment variables with your AWS credentials (in ~/.bashrc).

    export AWS_ACCESS_KEY_ID:  AWS Access Key ID
    export AWS_SECRET_ACCESS_KEY:  AWS Secret Access Key
    # export EC2_KEYPAIR=shak # optional

Get the code

    git clone https://shakfu@github.com/shakfu/ndnec2.git

Example
-------

Run 10 robochat instances in us-west-1

    ./ec2run.py --count 10 --name robochat --region us-west-1

SSH into your instance

    ssh ec2-user@ec2host

