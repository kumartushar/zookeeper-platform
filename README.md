Zookeeper Cluster
=================

Description
-----------

Apache ZooKeeper is an effort to develop and maintain an open-source server
which enables highly reliable distributed coordination. Learn more about
ZooKeeper on <http://zookeeper.apache.org>.

This cookbook focuses on deploying a Zookeeper cluster via Chef on *systemd*
managed distributions.

Usage
-----

### Easy Setup

Create a role `zookeeper-cluster` having `recipe['zookeeper-cluster']` in its
runlist and setting `node['zookeeper-cluster']['role']` to itself. Add this
role in the runlists of the nodes you want to use for your cluster. By default,
you need exactly 3 nodes.

By default, this cookbook includes the *java* cookbook in **systemd-service**
recipe, just before launching the service. You can deactivate this
behavior by setting `node['zookeeper-cluster']['install_java']` to false.

### Search

By default, the *config* recipe use a search to find the members of a cluster.
The search is parametrized by a role name, defined in attribute
`node['zookeeper-cluster']['role']` which default to *zookeeper-cluster*.
Node having this role in their expanded runlist will be considered in the same
zookeeper cluster. For safety reason, if search is used, you need to define
`node['zookeeper-cluster']['size']` (3 by default). The cookbook will return
(with success) until the search return *size* nodes. This ensures the
stability of the configuration during the initial startup of a cluster.

If you do not want to use search, it is possible to define
`node['zookeeper-cluster']['hosts']` with an array containing the hostnames of
the nodes of a zookeeper cluster. In this case, *size* attribute is ignored
and search deactivated.

### Test

This cookbook is fully tested through the installation of a working 3-nodes
cluster in docker hosts. This uses kitchen, docker and some monkey-patching.

For more information, see *.kitchen.yml* and *test* directory.

### Local cluster

You can also use this cookbook to install a zookeeper cluster locally. By
running `kitchen converge`, you will have a 3-nodes cluster available on your
workstation, each in its own docker host. You can then access it with:

    zkCli.sh -server (docker inspect \
      --format '{{.NetworkSettings.IPAddress}}' zookeeper-kitchen-01)

Changes
-------

### 1.0.0:

- Initial version with Centos 7 support

Requirements
------------

### Cookbooks

From <https://supermarket.chef.io>:
- java
- ark

### Gems

From <https://rubygems.org>:

- berkshelf
- test-kitchen
- kitchen-docker

### Platforms

A *systemd* managed distribution:
- RHEL Family 7, tested on Centos

Note: it should work fine on Debian 8 but the official docker image does not
allow systemd to work easily, so it could not be tested.

Attributes
----------

### Zookeeper Package

- `node['zookeeper-cluster']['version']`: Version of Zookeeper.
  Default is '3.4.6'.
- `node['zookeeper-cluster']['checksum']`: Checksum of Zookeeper package.
  Default
  is '01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994'.
- `node['zookeeper-cluster']['mirror']`: Apache mirror.
  Default is 'http://apache.mirrors.ovh.net/ftp.apache.org/dist/zookeeper'.

### Install Configuration

- `node['zookeeper-cluster']['user']`: User and group of zookeeper process.
  Default is 'zookeeper'.
- `node['zookeeper-cluster']['prefix_root']`: Where to put installation dir.
  Default is '/opt'.
- `node['zookeeper-cluster']['prefix_home']`: Where to link installation dir.
  Default is '/opt'.
- `node['zookeeper-cluster']['prefix_bin']`: Where to link binaries.
  Default is '/opt/bin'.
- `node['zookeeper-cluster']['log_dir']`: Log directory.
  Default is '/var/opt/zookeeper/log'.
- `node['zookeeper-cluster']['data_dir']`: Data directory.
  Default is '/var/opt/zookeeper/lib'.
- `node['zookeeper-cluster']['install_java']`: Include *java* cookbook.
  Default is true.
- `node['zookeeper-cluster']['auto_restart']`: Restart Zookeeper service
  if a configuration file change. Default is true.

### Cluster Configuration

- `node['zookeeper-cluster']['role']`: Role used by the search to find other
  nodes of the cluster. Default is 'zookeeper-cluster'.
- `node['zookeeper-cluster']['hosts']`: Hosts of the cluster, deactivate search
  if not empty. Default is [].
- `node['zookeeper-cluster']['size']`: Expected size of the cluster. Ignored if
  hosts is not empty. Default is 3.

### Zookeeper Configuration

- `node['zookeeper-cluster']['config']`: Base zookeeper configuration.
  Default is:

```text
  {
    'clientPort' => 2181,
    'dataDir' => node['zookeeper-cluster']['data_dir'],
    'tickTime' => 2000,
    'initLimit' => 5,
    'syncLimit' => 2
  }
```

Recipes
-------

### default

Run *install*, *create-user*, *config* and *systemd-service* recipes, in that
order.

### install

Install zookeeper with *ark* cookbook.

### create-user

Create zookeeper system user and group.

### config

Generate nodes list by search or by using hosts attribute. Merge it with base
configuration, then install *myid* and *zoo.cfg* files. Create work
directories: for data and logs.

### systemd-service

Install zookeeper service for systemd, enable and start it.
Run *java* cookbook as it is needed to launch zookeeper.

Resources/Providers
-------------------

None.

Contributing
------------

You are more than welcome to submit issues and merge requests to this project.
Note however that this cookbook will never support another supervisor than
*systemd*.

### Commits

Your commits must pass `git log --check` and messages should be formated
like this (based on this excellent
[post](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)):

```
Summarize change in 50 characters or less

Provide more detail after the first line. Leave one blank line below the
summary and wrap all lines at 72 characters or less.

If the change fixes an issue, leave another blank line after the final
paragraph and indicate which issue is fixed in the specific format
below.

Fix #42
```

Also do your best to factor commits appropriately, ie not too large with
unrelated things in the same commit, and not too small with the same small
change applied N times in N different commits. If there was some accidental
reformatting or whitespace changes during the course of your commits, please
rebase them away before submitting the PR.

### Files

All files must be 80 columns width formatted (actually 79), exception when it
is not possible.

License and Author
------------------

- Author:: Samuel Bernard (<samuel.bernard@s4m.io>)

```text
Copyright:: 2015, Sam4Mobile

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
