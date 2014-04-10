# encoding: UTF-8

include Rightscale::RightscaleTag

action :install do
  # Copy/Pasted (almost verbatim) from rs-application_php::tags, seems like it
  # should be in a library somewhere
  run_context.include_recipe 'rightscale_tag::default'

  # Set up application server tags
  rightscale_tag_application new_resource.load_balancer do
    bind_ip_address new_resource.listen_ip
    bind_port new_resource.listen_port.to_i
    vhost_path new_resource.vhost_path
    action :create
  end
end

action :attach do
  # Copy/Pasted (almost verbatim) from rs-application_php::application_backend,
  # seems like it should be in a library somewhere
  if find_load_balancer_servers(node, new_resource.load_balancer).empty?
    raise "No load balancer servers found in the deployment serving #{new_resource.load_balancer}!"
  end

  # Put this backend into consideration during tag queries
  log 'Tagging the application server to put it into consideration during tag queries...'
  machine_tag "application:active_#{new_resource.load_balancer}=true" do
    action :create
  end

  # Send remote recipe request
  log "Running recipe 'chef::do_client_converge' on all load balancers" +
        " with tags 'load_balancer:active_#{new_resource.load_balancer}=true'..."

  execute 'Attach to load balancer(s)' do
    command [
      'rs_run_recipe',
      '--name', 'chef::do_client_converge',
      '--recipient_tags', "load_balancer:active_#{new_resource.load_balancer}=true"
    ]
  end
end

action :detach do
  if find_load_balancer_servers(node, new_resource.load_balancer).empty?
    raise "No load balancer servers found in the deployment serving #{new_resource.load_balancer}!"
  end

  # Pull this backend from consideration during tag queries
  log '(Un)Tagging the application server to pull it out of consideration during tag queries...'
  machine_tag "application:active_#{new_resource.load_balancer}=true" do
    action :delete
  end

  # Send remote recipe request
  log "Running recipe 'chef::do_client_converge' on all load balancers" +
          " with tags 'load_balancer:active_#{new_resource.load_balancer}=true'..."

  execute 'Attach to load balancer(s)' do
    command [
      'rs_run_recipe',
      '--name', 'chef::do_client_converge',
      '--recipient_tags', "load_balancer:active_#{new_resource.load_balancer}=true"
    ]
  end
end
