#
# Author:: Samuel Bernard (<samuel.bernard@s4m.io>)
# Cookbook Name:: zookeeper-cluster
# Recipe:: systemd-service
#
# Copyright (c) 2015 Sam4Mobile
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
include_recipe "java" if node['zookeeper-cluster']['install_java']

# Enable/Start service
service "zookeeper" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
