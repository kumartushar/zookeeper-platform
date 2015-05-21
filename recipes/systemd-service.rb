#
# Cookbook Name:: zookeeper-cluster
# Recipe:: systemd-service
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install and launch zookeeper service through systemd
config_path = "#{node['zookeeper-cluster']['prefix_home']}/zookeeper/conf"
install_path = "#{node['zookeeper-cluster']['prefix_home']}/zookeeper"

  service_config = {
  :classpath => "#{install_path}/zookeeper.jar:#{install_path}/lib/*",
  :config_file => "#{config_path}/zoo.cfg",
  :log4j_file => "#{config_path}/log4j.properties"
}

# Install service file
template "/usr/lib/systemd/system/zookeeper.service" do
  variables     service_config
  mode          "0644"
  source        "zookeeper.service.erb"
end

# Java is needed by zookeeper
include_recipe "java"

# Enable/Start service
service "zookeeper" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
