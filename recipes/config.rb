#
# Author:: Samuel Bernard (<samuel.bernard@s4m.io>)
# Cookbook Name:: zookeeper-cluster
# Recipe:: config
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

::Chef::Recipe.send(:include, ClusterSearch)
cluster = cluster_search(node['zookeeper-cluster'])
return if cluster == nil

# Generate config
config = node['zookeeper-cluster']['config'].dup
cluster['hosts'].each_with_index {
  |v,i| config["server.#{i+1}"]="#{v}:2888:3888"
}
puts "Configuration: #{config}"

# Create work directories
[
  node['zookeeper-cluster']['log_dir'],
  node['zookeeper-cluster']['data_dir'],
].each do |path|
  directory path do
    owner node['zookeeper-cluster']['user']
    group node['zookeeper-cluster']['user']
    mode '0755'
    recursive true
    action :create
  end
end

# General zookeeper config
config_path = "#{node['zookeeper-cluster']['prefix_home']}/zookeeper/conf"

template "#{config_path}/zoo.cfg" do
  variables     :config => config
  mode          "0644"
  source        "zoo.cfg.erb"
end

# Create myid file
template "#{node['zookeeper-cluster']['data_dir']}/myid" do
  variables     :my_id => cluster['my_id']
  mode          "0644"
  source        "myid.erb"
end
