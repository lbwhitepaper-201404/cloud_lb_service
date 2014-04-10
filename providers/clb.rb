# encoding: UTF-8

action :install do
  chef_gem 'rumm'
end

action :attach do
  cred_file = ::File.join(ENV['HOME'], '.rummrc')
  region = node['rackspace']['region']
  helper = CloudLbService::Clb::Helper.new

  t = template cred_file do
    source '.rummrc.erb'
    mode 00600
    variables(
      region: region,
      username: new_resource.username,
      api_key: new_resource.password
    )
    action :nothing
  end
  t.run_action(:create)

  begin
    node = helper.node_id_from_ip(new_resource.load_balancer,
                                  new_resource.listen_ip)
    if node
      log "This node was already registered with #{new_resource.load_balancer} with ip #{new_resource.listen_ip} as node #{node}"
    else
      output = helper.add_node(
          new_resource.load_balancer, new_resource.listen_ip,
          new_resource.listen_port)
      raise Exception.new(output) unless $? == 0
    end
  ensure
    f = file cred_file do
      action :nothing
    end
    f.run_action(:delete)
  end
end

action :detach do
  cred_file = ::File.join(ENV['HOME'],'clb')
  region = node['rackspace']['region']
  helper = CloudLbService::Clb::Helper.new

  t = template cred_file do
    source '.rummrc.erb'
    mode 00600
    variables(
        region: region,
        username: new_resource.username,
        api_key: new_resource.password
    )
    action :nothing
  end
  t.run_action(:create)

  begin
    node = helper.node_id_from_ip(new_resource.load_balancer,
                                  new_resource.listen_ip)
    if node
      output = helper.detach_node(new_resource.load_balancer, node)
      raise Exception.new(output) unless $? == 0
    end
  ensure
    f = file cred_file do
      action :nothing
    end
    f.run_action(:delete)
  end
end