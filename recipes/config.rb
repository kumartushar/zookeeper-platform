#
# Cookbook Name:: zookeeper-cluster
# Recipe:: config
#
# Copyright (c) 2015 S4M, All Rights Reserved.

puts "\nStarting #{cookbook_name}::#{recipe_name}"

# Fetch role name of the cluster
cluster_role = node['zookeeper-cluster']['role']

# Fetch hosts based on a search
fqdn = node['fqdn']
puts "Searching in role #{cluster_role}"
hosts = search(:node, "roles:#{cluster_role}")
hosts = hosts.collect {|n| n['fqdn']}
hosts << fqdn unless hosts.include? fqdn
hosts = hosts.sort
puts "Hosts found: #{hosts}"

# My ID
my_id = (hosts.index fqdn)+1
puts "My ID: #{my_id}"

# Generate config
node_config = node['zookeeper-cluster']['config']
config = {}.merge node_config
hosts.each_with_index { |v,i| config["server.#{i+1}"]="#{v}:2888:3888" }
puts "Configuration: #{config}"

# General storm config
config_path = "#{node['zookeeper-cluster']['prefix_home']}/zookeeper/conf"

template "#{config_path}/zoo.cfg" do
  variables     :config => config
  mode          "0644"
  source        "zoo.cfg.erb"
end

puts "End of #{cookbook_name}::#{recipe_name}\n\n"
