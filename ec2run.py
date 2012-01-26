#!/usr/bin/env python
#
# This script allows users to manage EC2 instances.
#
# Assumes environment variables are set: 
#   AWS_ACCESS_KEY_ID:  AWS Access Key ID
#   AWS_SECRET_ACCESS_KEY:  AWS Secret Access Key
#
# Copyright 2011 Shakir James and Washington University in St. Louis.
# See LICENSE for details.
#

import sys
from boto import ec2
from time import sleep
from os import environ

# URLs to install scripts
STARTUP_SCRIPT = 'http://bit.ly/ec2ccnx'
# EC2 keypair
try:
    EC2_KEYPAIR = environ['EC2_KEYPAIR']
except KeyError:
    EC2_KEYPAIR = 'default'
# EC2 security group
EC2_SECURITY_GROUPS=('default', )
# Region names (availability zones)
REGION_US_E1 = 'us-east-1' # N. Virginia
REGION_US_W1 = 'us-west-1' # N. California
REGION_US_W2 = 'us-west-2' # Oregon
# Amazon Machine Images (AMIs) 
# from http://aws.amazon.com/amazon-linux-ami/
AMI_US_E1_32_EBS = 'ami-31814f58'
AMI_US_E1_64_EBS = 'ami-1b814f72'
AMI_US_W1_32_EBS = 'ami-11d68a54'
AMI_US_W1_64_EBS = 'ami-1bd68a5e'
AMI_US_W2_32_EBS = 'ami-38fe7308'
AMI_US_W2_64_EBS = 'ami-30fe7300'
AMI_IDS = {
    REGION_US_E1: { 
        't1.micro': AMI_US_E1_64_EBS, # EBS only (32-bit or 64-bit)
        'm1.small': AMI_US_E1_32_EBS, # 32-bit
        'm1.large': AMI_US_E1_64_EBS, # 64-bit
    },
    REGION_US_W1: { 
        't1.micro': AMI_US_W1_64_EBS,
        'm1.small': AMI_US_W1_32_EBS,
        'm1.large': AMI_US_W1_64_EBS,
    },
    REGION_US_W2: { 
        't1.micro': AMI_US_W2_64_EBS,
        'm1.small': AMI_US_W2_32_EBS,
        'm1.large': AMI_US_W2_64_EBS, 
    },
}
# Metadata tag name
TAG_NAME='Name'
TAG_VALUE='none' # default
# User_data script that runs when instance starts
# NOTE: this script runs as root when the instance boots
USER_DATA = """#!/bin/bash
set -e

wget -O install {script}
bash install {name} {gateway} {options} >> /root/install.log 2>&1
"""


def _get_user_data(**kwargs):
    """Return startup (user_data) script"""
    return USER_DATA.format(script=STARTUP_SCRIPT,
                            name=kwargs.get('name', ''),
                            gateway=kwargs.get('gateway', ''),
                            options=kwargs.get('options', ''))
    

def _get_conn(region):
    """Return EC2 connection
    Args:
        region: the name of region to connect to
    """
    ### TODO: cache connection
    try:
        aws_access_key_id = environ['AWS_ACCESS_KEY_ID']
        aws_secret_access_key = environ['AWS_SECRET_ACCESS_KEY']
    except KeyError:
        raise ValueError('Please set your environment variables: '
                        'AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY')
    return ec2.connect_to_region(region,
                aws_access_key_id=aws_access_key_id,
                aws_secret_access_key=aws_secret_access_key)


def _get_instances(region, **kwargs):
    """Return list of instance objects
    Args:
        name: return instances with TAG_NAME=name (optional)
    """
    filters=None
    if kwargs.get('name', ''):
        filters = {'tag:{0}'.format(TAG_NAME): kwargs['name']}
    conn = _get_conn(region)
    # instances may temporarily include recently terminated instances  
    rs = conn.get_all_instances(filters=filters)
    return (i for r in rs for i in r.instances if i.state != u'terminated')    


def run(region, count=1, type='t1.micro', sleep_time=5.0, **kwargs):
    """Run EC2 instance 
    Args:
      region: EC2 region
      count: number of instances to start
      type:  instance type
      sleep_time: poll for 'running' instance in sleep_time seconds
    """
    try:
        ami_id = AMI_IDS[region][type]
    except KeyError:
        raise ValueError('No AMI for {0} in {1}'.format(type, region))
    conn = _get_conn(region)
    # start instances
    print('Launching {0} {1} in {2} ...'.format(count, type, region))    
    res = conn.run_instances(ami_id, 
            min_count=count,
            max_count=count,
            key_name=EC2_KEYPAIR,
            security_groups=EC2_SECURITY_GROUPS,
            user_data=_get_user_data(**kwargs), 
            instance_type=type)
    instances = res.instances
    # tag instances  
    if kwargs.get('name', ''):
        ids = [inst.id for inst in instances]
        conn.create_tags( ids, {TAG_NAME: kwargs['name']})
    # wait for 'running' state
    ninst = len(instances)
    while True:
        print '.',
        sys.stdout.flush()
        nrun = len([inst for inst in instances if inst.state == u'running'])
        if nrun == ninst:
            break
        sleep(sleep_time)
        for inst in instances:
            inst.update()
    print('\n{0} instances started.'.format(ninst))
    print_hosts(region, instances=instances)


def terminate(region, **kwargs):
    """Terminate instances"""
    instances = _get_instances(region, **kwargs)
    if not instances:
        return
    conn = _get_conn(region)
    instance_ids = [inst.id for inst in instances]
    conn.terminate_instances(instance_ids)


def print_status(region, requests=False, **kwargs):
    """Print the state of instances"""
    instances = _get_instances(region, **kwargs)    
    print(region)
    if not instances:
        print('\tNone.')
        return
    states = {}
    for inst in instances:
        states[inst.state] = states.setdefault(inst.state, 0) + 1
    for state, count in states.iteritems(): 
        print('\t{0} {1}'.format(state, count))


def print_hosts(region, instances=None, **kwargs):
    """Print hostnames of running instances
    Args:
        region: EC2 region (optional if instances is not None)
        instances: list of instance objects
    """
    if instances is None:
        instances = _get_instances(region, **kwargs)
    if not instances:
        print('No running instances.')
        return
    for inst in instances:
        tag_value = inst.tags.get(TAG_NAME, TAG_VALUE)
        print('\t{0:<15}{1}'.format(tag_value, inst.public_dns_name))


def main():
    import optparse
    usage = 'usage: %prog [options]'
    parser = optparse.OptionParser(usage)  
    parser.add_option('-c', '--count',
                        dest='count',
                        type='int',
                        metavar='N',
                        default=1,
                        help='number of instances N [default: %default]')
    parser.add_option('-l', '--list',
                        dest='list',
                        default=False,
                        action='store_true',
                        help='print hostnames of running instances')  
    parser.add_option('-r', '--region',
                        dest='region',
                        type='string',
                        metavar='REGION',
                        default=REGION_US_E1,
                        help='EC2 region')                        
    parser.add_option('-s', '--status',
                        dest='status',
                        default=False,
                        action='store_true',
                        help='print instant states')
    parser.add_option('-t', '--terminate',
                        dest='terminate',
                        default=False,
                        action='store_true',
                        help='terminate instances')                        
    parser.add_option('--type',
                        dest='type',
                        type='string',
                        metavar='TYPE',
                        default='t1.micro',
                        help='instance type TYPE [default: %default]')
    ss_group = optparse.OptionGroup(parser, 'Startup script options')
    ss_group.add_option('-n', '--name',
                        dest='name',
                        type='string',
                        default='',
                        help='application type')
    ss_group.add_option('-g','--gateway',
                        dest='gateway',
                        type='string',
                        default='',
                        help='gateway ccnx router')
    ss_group.add_option('-o', '--options',
                        dest='options',
                        type='string',
                        default='',
                        help='commandline options')
    parser.add_option_group(ss_group)
    
    (options, args) = parser.parse_args()
    kwargs = {
        'name': options.name,
        'gateway': options.gateway,
        'options': options.options,
    }
    if options.terminate:
        terminate(options.region, **kwargs)
    elif options.list:
        print_hosts(options.region, **kwargs)
    elif options.status:
        print_status(options.region, **kwargs)
    else:
        try:
            run(options.region, options.count, options.type, **kwargs)
        except ValueError as msg:
            print('Error: {0}'.format(msg))


if __name__ == '__main__':
    main()