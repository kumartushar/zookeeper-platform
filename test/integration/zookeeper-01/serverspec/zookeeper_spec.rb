#
# Copyright (c) 2015-2016 Sam4Mobile, 2017 Make.org
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

require 'spec_helper'

describe 'Zookeeper Daemon' do
  it 'is running' do
    expect(service('zookeeper')).to be_running
  end

  it 'is launched at boot' do
    expect(service('zookeeper')).to be_enabled
  end

  it 'is listening on port 2181' do
    expect(port(2181)).to be_listening
  end
end

describe 'Zookeeper Configuration' do
  describe file('/opt/zookeeper/conf/zoo.cfg') do
    its(:content) { should eq <<-eos.gsub(/^ {4}/, '') }
    # Produced by Chef -- changes will be overwritten

    clientPort=2181
    dataDir=/var/opt/zookeeper/lib
    tickTime=2000
    initLimit=5
    syncLimit=2
    maxClientCnxns=100
    server.1=zookeeper-01-centos-7:2888:3888
    server.2=zookeeper-02-centos-7:2888:3888
    server.3=zookeeper-03-centos-7:2888:3888
    eos
  end

  describe file('/var/opt/zookeeper/lib/myid') do
    its(:content) { should eq "1\n" }
  end
end

describe 'Zookeeper Cluster' do # rubocop:disable Metrics/BlockLength
  check = lambda do |i|
    r = zoo_cmd('ls /', "zookeeper-#{i}-centos-7:2181")
    r.include?('(CONNECTED)')
  end

  (1..10).each do |try|
    puts "Waiting for Zookeeper cluster… Try ##{try}/10, waiting #{try - 1}s"
    sleep(try)
    break if %w[01 02 03].reduce(true) { |a, e| a && check.call(e) }
  end

  it 'should be totally connected' do
    expect(%w[01 02 03].reduce(true) { |a, e| a && check.call(e) }).to be(true)
  end

  it 'should locally create /kitchen containing "Data"' do
    # Create a node locally
    expect(zoo_cmd('create /kitchen Data')).to(
      contain("Created /kitchen\n").or(
        contain("Node already exists: /kitchen\n")
      )
    )
  end

  # Check on all nodes
  %w[01 02 03].each do |i|
    it "should have /kitchen on zookeeper-#{i}-centos-7" do
      get = zoo_cmd('get /kitchen', "zookeeper-#{i}-centos-7:2181")
      expect(get).to contain("Data\n")
    end
    it "should NOT have /not_kitchen on zookeeper-#{i}-centos-7" do
      get = zoo_cmd('get /not_kitchen', "zookeeper-#{i}-centos-7:2181")
      expect(get).to contain("Node does not exist: /not_kitchen\n")
    end
  end
end
