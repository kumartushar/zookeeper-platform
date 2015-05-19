#
# Cookbook Name:: zookeeper-cluster
# Recipe:: install
#
# Copyright (c) 2015 S4M, All Rights Reserved.

puts "\nStarting #{cookbook_name}::#{recipe_name}"

# tar may not be installed by default
package 'tar'

# Shorten variables
version = node['zookeeper-cluster']['version']
zookeeper_url = "#{node['zookeeper-cluster']['mirror']}/zookeeper-#{version}"
zookeeper_artifact = "zookeeper-#{version}.tar.gz"

# Create prefix directories
[
  node['zookeeper-cluster']['prefix_root'],
  node['zookeeper-cluster']['prefix_home'],
  node['zookeeper-cluster']['prefix_bin']
].each do |path|
  directory path do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end
end

# Install zookeeper package with ark
ark "zookeeper" do
  action        :install
  url           "#{zookeeper_url}/#{zookeeper_artifact}"
  prefix_root   node['zookeeper-cluster']['prefix_root']
  prefix_home   node['zookeeper-cluster']['prefix_home']
  prefix_bin    node['zookeeper-cluster']['prefix_bin']
  has_binaries  [ 'bin/zkCli.sh', 'bin/zkCleanup.sh', 'bin/zkServer.sh' ]
  checksum      node['zookeeper-cluster']['checksum']
  version       node['zookeeper-cluster']['version']
  owner         node['zookeeper-cluster']['user']
end

puts "End of #{cookbook_name}::#{recipe_name}\n\n"
