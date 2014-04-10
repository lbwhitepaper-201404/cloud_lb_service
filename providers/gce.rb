# encoding: UTF-8

action :install do
  node.override['google_cloud']['auth']['credential_file'] = new_resource.password

  instance_id = ''
  zone = ''
  region = ''
  project = ''

  if ::File.exist?('/var/spool/cloud/meta-data.rb')
    require '/var/spool/cloud/meta-data'

    unless ENV.key?('GCE_INSTANCE_ID')
      raise Exception.new("This instance doesn't seem to be running on GCE")
    end

    project = ENV['GCE_PROJECT_ID']
    zone = ENV['GCE_ZONE'].gsub(ENV['GCE_NUMERIC_PROJECT_ID'], ENV['GCE_PROJECT_ID'])
    region = ENV['GCE_ZONE'].match(/[a-z]{2}-[a-z]*[0-9]*/)
    instance_id = ENV['GCE_HOSTNAME'].match(/i-[a-z0-9]*/)

    node.override['google_cloud']['project'] = project
    node.override['google_cloud']['region'] = region
    node.override['google_cloud']['instance_id'] = instance_id
    node.override['google_cloud']['zone_id'] = zone
  else
    raise Exception.new('Not running on a RightScale managed server!')
  end

  # Because these get evaluated in an attributes file sorta "before" compile
  # it needs to be set on the role
  #node.override[:rsc_google_cloud][:instance_id] =
  #    'not used cause the google_cloud stuff is set above'
  #node.override[:rsc_google_cloud][:datacenter] =
  #    'not used cause the google_cloud stuff is set above'

  run_context.include_recipe 'rsc_google_cloud::default'
  run_context.include_recipe 'google_cloud::default'
end

action :attach do
  instance_id = ''
  zone = ''
  region = ''
  project = ''

  if ::File.exist?('/var/spool/cloud/meta-data.rb')
    require '/var/spool/cloud/meta-data'

    unless ENV.key?('GCE_INSTANCE_ID')
      raise Exception.new("This instance doesn't seem to be running on GCE")
    end

    project = ENV['GCE_PROJECT_ID']
    zone = ENV['GCE_ZONE'].gsub(ENV['GCE_NUMERIC_PROJECT_ID'], ENV['GCE_PROJECT_ID'])
    region = ENV['GCE_ZONE'].match(/[a-z]{2}-[a-z]*[0-9]*/)
    instance_id = ENV['GCE_HOSTNAME'].match(/i-[a-z0-9]*/)

    node.override['google_cloud']['project'] = project
    node.override['google_cloud']['region'] = region
    node.override['google_cloud']['instance_id'] = instance_id
    node.override['google_cloud']['zone_id'] = zone
  else
    raise Exception.new('Not running on a RightScale managed server!')
  end

  # Because these get evaluated in an attributes file sorta "before" compile
  # it needs to be set on the role
  #node.override[:rsc_google_cloud][:instance_id] =
  #    'not used cause the google_cloud stuff is set above'
  #node.override[:rsc_google_cloud][:datacenter] =
  #    'not used cause the google_cloud stuff is set above'

  google_cloud_lb "attach" do
    service_lb_name new_resource.load_balancer
    action :attach
  end
end

action :detach do
  instance_id = ''
  zone = ''
  region = ''
  project = ''

  if ::File.exist?('/var/spool/cloud/meta-data.rb')
    require '/var/spool/cloud/meta-data'

    unless ENV.key?('GCE_INSTANCE_ID')
      raise Exception.new("This instance doesn't seem to be running on GCE")
    end

    project = ENV['GCE_PROJECT_ID']
    zone = ENV['GCE_ZONE'].gsub(ENV['GCE_NUMERIC_PROJECT_ID'], ENV['GCE_PROJECT_ID'])
    region = ENV['GCE_ZONE'].match(/[a-z]{2}-[a-z]*[0-9]*/)
    instance_id = ENV['GCE_HOSTNAME'].match(/i-[a-z0-9]*/)

    node.override['google_cloud']['project'] = project
    node.override['google_cloud']['region'] = region
    node.override['google_cloud']['instance_id'] = instance_id
    node.override['google_cloud']['zone_id'] = zone
  else
    raise Exception.new('Not running on a RightScale managed server!')
  end

  # Because these get evaluated in an attributes file sorta "before" compile
  # it needs to be set on the role
  #node.override[:rsc_google_cloud][:instance_id] =
  #    'not used cause the google_cloud stuff is set above'
  #node.override[:rsc_google_cloud][:datacenter] =
  #    'not used cause the google_cloud stuff is set above'

  google_cloud_lb "detach" do
    service_lb_name new_resource.load_balancer
    action :detach
  end
end
