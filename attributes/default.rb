#
# Default attributes
#

default['zookeeper-cluster']['role'] = 'zookeeper-cluster'

default['zookeeper-cluster']['config'] = {
  'clientPort' => 2181,
  'dataDir' => '/var/lib/zookeeper',
  'tickTime' => 2000,
  'initLimit' => 5,
  'syncLimit' => 2
}
