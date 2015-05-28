require 'spec_helper'

describe 'Zookeeper Daemon' do
  it 'is running' do
    expect(service("zookeeper")).to be_running
  end

  it 'is launch at boot' do
    expect(service('zookeeper')).to be_enabled
  end

  it 'is listening on port 2181' do
    expect(port(2181)).to be_listening
  end
end

describe 'Zookeeper Cluster' do
  it 'should create /kitchen containing "Data"' do
    # Create a node locally
    client = Zookeeper.new("localhost:2181")
    client.create({:path => "/kitchen", :data => "Data"})
    client.close
  end

  # Check on all nodes
  %w[01 02 03].each do |i|
    it "should have /kitchen on zookeeper-kitchen-#{i}.kitchen" do
      client = Zookeeper.new("zookeeper-kitchen-#{i}.kitchen:2181")
      data = client.get(:path => "/kitchen")
      expect(data[:stat].exists?).to eq(true)
      expect(data[:data]).to eq("Data")
      client.close
    end
  end
end
