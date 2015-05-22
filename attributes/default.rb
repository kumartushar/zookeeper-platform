#
# Default attributes
#

default['zookeeper-cluster']['version']     = '3.4.6'
default['zookeeper-cluster']['checksum']    =
  '01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994'
default['zookeeper-cluster']['mirror']      =
  'http://apache.mirrors.ovh.net/ftp.apache.org/dist/zookeeper'
  'http://www.poolsaboveground.com/apache/zookeeper'

default['zookeeper-cluster']['user']        = 'zookeeper'
default['zookeeper-cluster']['prefix_root'] = '/opt'
default['zookeeper-cluster']['prefix_home'] = '/opt'
default['zookeeper-cluster']['prefix_bin']  = '/opt/bin'
default['zookeeper-cluster']['log_dir']     = '/var/opt/zookeeper/log'
default['zookeeper-cluster']['data_dir']    = '/var/opt/zookeeper/lib'


default['zookeeper-cluster']['role']        = 'zookeeper-cluster'
default['zookeeper-cluster']['hosts']       = [] # Use search when empty
default['zookeeper-cluster']['size']        = 3 # Ignored hosts is non empty

default['zookeeper-cluster']['config']      = {
  'clientPort' => 2181,
  'dataDir' => node['zookeeper-cluster']['data_dir'],
  'tickTime' => 2000
}
