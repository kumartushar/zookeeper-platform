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
default['zookeeper-cluster']['version']     = '3.4.6'
default['zookeeper-cluster']['checksum']    =
  '01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994'
default['zookeeper-cluster']['mirror']      =
  'http://apache.mirrors.ovh.net/ftp.apache.org/dist/zookeeper'

# Zookeeper installation
default['zookeeper-cluster']['user']        = 'zookeeper'
default['zookeeper-cluster']['prefix_root'] = '/opt'
default['zookeeper-cluster']['prefix_home'] = '/opt'
default['zookeeper-cluster']['prefix_bin']  = '/opt/bin'
default['zookeeper-cluster']['log_dir']     = '/var/opt/zookeeper/log'
default['zookeeper-cluster']['data_dir']    = '/var/opt/zookeeper/lib'
default['zookeeper-cluster']['java']        = {
  'centos' => 'java-1.8.0-openjdk-headless'
}
default['zookeeper-cluster']['auto_restart']= true

# Cluster configuration
default['zookeeper-cluster']['role']        = 'zookeeper-cluster'
default['zookeeper-cluster']['hosts']       = [] # Use search when empty
default['zookeeper-cluster']['size']        = 3 # Ignored hosts is non empty

# Zookeeper configuration
default['zookeeper-cluster']['config']      = {
  'clientPort' => 2181,
  'dataDir' => node['zookeeper-cluster']['data_dir'],
  'tickTime' => 2000,
  'initLimit' => 5,
  'syncLimit' => 2
}
