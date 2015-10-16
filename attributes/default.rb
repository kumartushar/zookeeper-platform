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
default['zookeeper-platform']['user']        = 'zookeeper'
default['zookeeper-platform']['prefix_root'] = '/opt'
default['zookeeper-platform']['prefix_home'] = '/opt'
default['zookeeper-platform']['prefix_bin']  = '/opt/bin'
default['zookeeper-platform']['log_dir']     = '/var/opt/zookeeper/log'
default['zookeeper-platform']['data_dir']    = '/var/opt/zookeeper/lib'
default['zookeeper-platform']['java']        = {
  'centos' => 'java-1.8.0-openjdk-headless'
}
default['zookeeper-platform']['auto_restart']= true

# Cluster configuration
default['zookeeper-platform']['role']        = 'zookeeper-platform'
default['zookeeper-platform']['hosts']       = [] # Use search when empty
default['zookeeper-platform']['size']        = 3 # Ignored hosts is non empty

# Zookeeper configuration
default['zookeeper-platform']['config']      = {
  'clientPort' => 2181,
  'dataDir' => node['zookeeper-platform']['data_dir'],
  'tickTime' => 2000,
  'initLimit' => 5,
  'syncLimit' => 2
}
