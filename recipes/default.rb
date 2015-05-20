#
# Cookbook Name:: zookeeper-cluster
# Recipe:: default
#
# Copyright (c) 2015 S4M, All Rights Reserved.

include_recipe "#{cookbook_name}::install"
include_recipe "#{cookbook_name}::create-user"
include_recipe "#{cookbook_name}::config"
