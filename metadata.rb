name 'zookeeper-platform'
maintainer 'Sam4Mobile'
maintainer_email 'dps.team@s4m.io'
license 'Apache 2.0'
description 'Installs/Configures a Zookeeper cluster using systemd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://gitlab.com/s4m-chef-repositories/zookeeper-platform'
issues_url 'https://gitlab.com/s4m-chef-repositories/zookeeper-platform/issues'
version '1.2.0'

supports 'centos',  '>= 7.1'

depends 'ark'
depends 'cluster-search'
