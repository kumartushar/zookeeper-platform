name 'zookeeper-cluster'
maintainer 'Sam4Mobile'
maintainer_email 'samuel.bernard@s4m.io'
license 'Apache 2.0'
description 'Installs/Configures a Zookeeper cluster using systemd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://gitlab.com/s4m-chef-repositories/zookeeper-cluster'
issues_url 'https://gitlab.com/s4m-chef-repositories/zookeeper-cluster/issues'
version '1.0.0'

supports 'centos',  '>= 7'

depends 'ark'
depends 'cluster-search'
depends 'java'
