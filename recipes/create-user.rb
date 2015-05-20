#
# Cookbook Name:: zookeeper-cluster
# Recipe:: create-user
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Create zookeeper-service group & user
group node['zookeeper-cluster']['user'] do
end

user node['zookeeper-cluster']['user'] do
  gid node['zookeeper-cluster']['user']
  shell '/bin/nologin'
  system true
  action :create
end
