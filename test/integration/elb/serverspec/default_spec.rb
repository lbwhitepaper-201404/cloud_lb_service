# encoding: UTF-8
require 'serverspec'
require 'pathname'
require 'json'

include Serverspec::Helper::Exec

RSpec.configure do |conf|
  conf.path = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
end

describe 'Dependencies' do
  describe command('which unzip') do
    its(:stdout) { should include('unzip') }
  end

  describe command('which java') do
    its(:stdout) { should include('java') }
  end
end

describe 'AWS Elastic Load Balancer' do
  it 'installs tools' do
    ::File.exist?('/opt/elb/bin/elb-create-lb')
  end
end
