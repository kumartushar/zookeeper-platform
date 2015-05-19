#
# Cookbook Name:: zookeeper-cluster
# Recipe:: default
#
# Copyright (c) 2015 S4M, All Rights Reserved.

puts "\nStarting #{cookbook_name}::#{recipe_name}"

include_recipe "#{cookbook_name}::install"
include_recipe "#{cookbook_name}::config"

puts "End of #{cookbook_name}::#{recipe_name}\n\n"
