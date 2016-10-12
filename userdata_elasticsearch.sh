#!/bin/bash

#install elasiticsearch
yum update -y
cd /root/
export ELASTICSEARCH_RPM='https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.4.1/elasticsearch-2.4.1.rpm'
wget $ELASTICSEARCH_RPM
export YUM_INSTALL_ELASTICSEARCH='elasticsearch-2.4.1.rpm'
yum install $YUM_INSTALL_ELASTICSEARCH -y

#install elasticsearch plugins
cd /usr/share/elasticsearch/
./bin/plugin install mobz/elasticsearch-head
./bin/plugin install lmenezes/elasticsearch-kopf/
./bin/plugin install cloud-aws

#install Kibana
cd /root/
export KIBANA_RPM='https://download.elastic.co/kibana/kibana/kibana-4.6.1-x86_64.rpm'
wget $KIBANA_RPM
export YUM_INSTALL_KIBANA='kibana-4.6.1-x86_64.rpm'
yum install $YUM_INSTALL_KIBANA -y

#install ansible and git
meta=http://169.254.169.254/latest/meta-data
export instance_id=`curl --silent $meta/instance-id`
yum --enablerepo epel install jq git -y > /tmp/yum.log 2>&1

# ssm install
# this tool helps manage and configure instances
#we can send commands and see results without logging into each of the instances within out fleet
#http://www.awsomeblog.com/amazon-ec2-simple-systems-manager/
cd /tmp
curl https://amazon-ssm-${region}.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm -o amazon-ssm-agent.rpm
yum install -y amazon-ssm-agent.rpm >> /tmp/yum.log 2>&1
