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

# Zookeeper package
default['zookeeper-platform']['version']     = '3.4.6'
default['zookeeper-platform']['checksum']    =
  '01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994'
default['zookeeper-platform']['mirror']      =
  'http://apache.mirrors.ovh.net/ftp.apache.org/dist/zookeeper'

# Zookeeper installation
# User and group of zookeeper process
default['zookeeper-platform']['user']        = 'zookeeper'
# Where to put installation dir
default['zookeeper-platform']['prefix_root'] = '/opt'
# Where to link installation dir
default['zookeeper-platform']['prefix_home'] = '/opt'
# Where to link binaries
default['zookeeper-platform']['prefix_bin']  = '/opt/bin'
# Log directory
default['zookeeper-platform']['log_dir']     = '/var/opt/zookeeper/log'
# Data directory
default['zookeeper-platform']['data_dir']    = '/var/opt/zookeeper/lib'
# Java package to install by platform
default['zookeeper-platform']['java']        = {
  'centos' => 'java-1.8.0-openjdk-headless'
}
# Restart Zookeeper service if a configuration file change
default['zookeeper-platform']['auto_restart']= true

# Cluster configuration
# Role used by the search to find other nodes of the cluster
default['zookeeper-platform']['role']        = 'zookeeper-platform'
# Hosts of the cluster, deactivate search if not empty
default['zookeeper-platform']['hosts']       = []
# Expected size of the cluster. Ignored if hosts is not empty
default['zookeeper-platform']['size']        = 3

# Zookeeper configuration
default['zookeeper-platform']['config']      = {
  'clientPort' => 2181,
  'dataDir' => node['zookeeper-platform']['data_dir'],
  'tickTime' => 2000,
  'initLimit' => 5,
  'syncLimit' => 2
}
