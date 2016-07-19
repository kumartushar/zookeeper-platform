#
# Copyright (c) 2015-2016 Sam4Mobile
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

# tar may not be installed by default
package 'tar' do
  retries node['zookeeper-platform']['package_retries']
end

# Shorten variables
version = node['zookeeper-platform']['version']
zookeeper_url = "#{node['zookeeper-platform']['mirror']}/zookeeper-#{version}"
zookeeper_artifact = "zookeeper-#{version}.tar.gz"

# Create prefix directories
[
  node['zookeeper-platform']['prefix_root'],
  node['zookeeper-platform']['prefix_home'],
  node['zookeeper-platform']['prefix_bin']
].uniq.each do |dir_path|
  directory "zookeeper-platform:#{dir_path}" do
    path dir_path
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end
end

# Install zookeeper package with ark
ark 'zookeeper' do
  action :install
  url "#{zookeeper_url}/#{zookeeper_artifact}"
  prefix_root node['zookeeper-platform']['prefix_root']
  prefix_home node['zookeeper-platform']['prefix_home']
  prefix_bin node['zookeeper-platform']['prefix_bin']
  has_binaries [] # zookeeper script does not work when linked
  checksum node['zookeeper-platform']['checksum']
  version node['zookeeper-platform']['version']
end

# Symbolic link for zookeeper jar to simplify service file
install_dir = "#{node['zookeeper-platform']['prefix_home']}/zookeeper"
link "#{install_dir}/zookeeper.jar" do
  to "#{install_dir}/zookeeper-#{version}.jar"
end
