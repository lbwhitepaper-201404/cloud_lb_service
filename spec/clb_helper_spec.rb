require 'rspec'
require 'flexmock'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'libraries', 'clb_helper'))

RSpec.configure do |c|
  c.mock_with(:flexmock)
end

describe CloudLbService::Clb::Helper do
  context :get_nodes do
    it 'parses show nodes output' do
      output = <<EOF
Nodes:
  id: 123456, address: 10.0.0.1, condition: ENABLED, status: ONLINE, weight:
  id: 234567, address: 10.0.0.2, condition: ENABLED, status: ONLINE, weight:
EOF

      helper = CloudLbService::Clb::Helper.new
      flexmock(helper)
        .should_receive('shell_execute').and_return(output)

      nodes = helper.get_nodes('lb')
      nodes.length.should == 2
    end
  end

  context :node_id_from_ip do
    it 'returns the right id' do
      output = <<EOF
Nodes:
  id: 123456, address: 10.0.0.1, condition: ENABLED, status: ONLINE, weight:
  id: 234567, address: 10.0.0.2, condition: ENABLED, status: ONLINE, weight:
EOF

      helper = CloudLbService::Clb::Helper.new
      flexmock(helper)
        .should_receive('shell_execute').and_return(output)

      helper.node_id_from_ip('lb', '10.0.0.2').should == '234567'
    end
  end
end
