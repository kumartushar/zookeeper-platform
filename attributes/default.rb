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
default['zookeeper-platform']['version'] = '3.4.7'
default['zookeeper-platform']['checksum'] =
  '2e043e04c4da82fbdb38a68e585f3317535b3842c726e0993312948afcc83870'
default['zookeeper-platform']['mirror'] =
  'http://archive.apache.org/dist/zookeeper/'

# Zookeeper installation
# User and group of zookeeper process
default['zookeeper-platform']['user'] = 'zookeeper'
# Where to put installation dir
default['zookeeper-platform']['prefix_root'] = '/opt'
# Where to link installation dir
default['zookeeper-platform']['prefix_home'] = '/opt'
# Where to link binaries
default['zookeeper-platform']['prefix_bin'] = '/opt/bin'
# Log directory
default['zookeeper-platform']['log_dir'] = '/var/opt/zookeeper/log'
# Data directory
default['zookeeper-platform']['data_dir'] = '/var/opt/zookeeper/lib'
# Java package to install by platform
default['zookeeper-platform']['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless'
}
# Restart Zookeeper service if a configuration file change
default['zookeeper-platform']['auto_restart'] = true

# Cluster configuration
# Role used by the search to find other nodes of the cluster
default['zookeeper-platform']['role'] = 'zookeeper-platform'
# Hosts of the cluster, deactivate search if not empty
default['zookeeper-platform']['hosts'] = []
# Expected size of the cluster. Ignored if hosts is not empty
default['zookeeper-platform']['size'] = 3

# Zookeeper configuration
default['zookeeper-platform']['config'] = {
  'clientPort' => 2181,
  'dataDir' => node['zookeeper-platform']['data_dir'],
  'tickTime' => 2000,
  'initLimit' => 5,
  'syncLimit' => 2
}

# JVM configuration
# {key => value} which gives "key=value" or just "key" if value is nil
default['zookeeper-platform']['jvm_opts'] = {
  '-Dcom.sun.management.jmxremote' => nil,
  '-Dcom.sun.management.jmxremote.authenticate' => false,
  '-Dcom.sun.management.jmxremote.ssl' => false,
  '-Dcom.sun.management.jmxremote.port' => 2191,
  '-Djava.rmi.server.hostname' => node['fqdn']
}

# log4j configuration
default['zookeeper-platform']['log4j'] = {
  'log4j.rootLogger' => 'INFO, ROLLINGFILE',
  'log4j.appender.CONSOLE' => 'org.apache.log4j.ConsoleAppender',
  'log4j.appender.CONSOLE.Threshold' => 'INFO',
  'log4j.appender.CONSOLE.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.CONSOLE.layout.ConversionPattern' =>
    '%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n',
  'log4j.appender.ROLLINGFILE' => 'org.apache.log4j.RollingFileAppender',
  'log4j.appender.ROLLINGFILE.Threshold' => 'INFO',
  'log4j.appender.ROLLINGFILE.File' =>
    "#{node['zookeeper-platform']['log_dir']}/zookeeper.log",
  'log4j.appender.ROLLINGFILE.MaxFileSize' => '10MB',
  'log4j.appender.ROLLINGFILE.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.ROLLINGFILE.layout.ConversionPattern' =>
    '%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n',
  'log4j.appender.TRACEFILE' => 'org.apache.log4j.FileAppender',
  'log4j.appender.TRACEFILE.Threshold' => 'TRACE',
  'log4j.appender.TRACEFILE.File' =>
    "#{node['zookeeper-platform']['log_dir']}/zookeeper_trace.log",
  'log4j.appender.TRACEFILE.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.TRACEFILE.layout.ConversionPattern' =>
    '%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L][%x] - %m%n'
}
