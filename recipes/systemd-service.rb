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
config_path = "#{node['zookeeper-platform']['prefix_home']}/zookeeper/conf"
install_path = "#{node['zookeeper-platform']['prefix_home']}/zookeeper"

service_config = {
  :classpath => "#{install_path}/zookeeper.jar:#{install_path}/lib/*",
  :config_file => "#{config_path}/zoo.cfg",
  :log4j_file => "#{config_path}/log4j.properties"
}

# Install service file, reload systemd daemon if necessary
execute "systemd-reload" do
  command "systemctl daemon-reload"
  action :nothing
end

template "/usr/lib/systemd/system/zookeeper.service" do
  variables     service_config
  mode          "0644"
  source        "zookeeper.service.erb"
  notifies      :run, 'execute[systemd-reload]', :immediately
end

# Java is needed by Kafka, can install it with package
java_package = node['zookeeper-platform']['java'][node['platform']]
package java_package if !java_package.to_s.empty?

# Configuration files to be subscribed
if node['zookeeper-platform']['auto_restart']
  config_files = [
    "#{config_path}/zoo.cfg",
    "#{config_path}/log4j.properties",
    "#{node['zookeeper-platform']['data_dir']}/myid"
  ].map do |path|
    "template[#{path}]"
  end
else config_files = []
end

# Enable/Start service
service "zookeeper" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
  subscribes :restart, config_files
end
