#
# Cookbook Name:: zookeeper-cluster
# Recipe:: install
#
# Copyright (c) 2015 S4M, All Rights Reserved.

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
  has_binaries  [] # zookeeper script does not work when linked
  checksum      node['zookeeper-cluster']['checksum']
  version       node['zookeeper-cluster']['version']
end

# Symbolic link for zookeeper jar to simplify service file
install_dir = "#{node['zookeeper-cluster']['prefix_home']}/zookeeper"
link "#{install_dir}/zookeeper.jar" do
  to "#{install_dir}/zookeeper-#{version}.jar"
end
