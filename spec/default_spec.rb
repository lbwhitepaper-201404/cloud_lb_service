# encoding: UTF-8
require 'chefspec'
require 'chefspec/berkshelf'

describe 'cloud_lb_service::default' do
  describe 'with elb service' do
    let(:chef_run) do
      ChefSpec::Runner.new(step_into: ['cloud_lb_service']) do |node|
        node.set['cloud_lb_service']['type'] = 'elb'
        node.set['cloud_lb_service']['elb_home'] = '/foo'
        node.set['network'] = {
          interfaces: {
            eth0: {
              addresses: {
                '10.0.0.1' => {}
              }
            }
          }
        }
      end.converge(described_recipe)
    end

    describe 'dependencies' do
      it 'installs unzip' do
        expect(chef_run).to install_package('unzip')
      end

      it 'includes java' do
        expect(chef_run).to include_recipe('java')
      end

      it 'includes apt' do
        expect(chef_run).to include_recipe('apt')
      end
    end

    it 'creates elb_home' do
      expect(chef_run).to create_directory('/foo')
    end
  end
end
