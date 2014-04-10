# encoding: UTF-8
action :install do
  elb_zipfile = ::File.join(Chef::Config[:file_cache_path],'elb.zip')
  elb_home = node['cloud_lb_service']['elb_home']

  run_context.include_recipe 'apt'
  run_context.include_recipe 'java'
  run_context.include_recipe 'java::set_java_home'

  %w(unzip).each do |p|
    package p
  end

  directory node['cloud_lb_service']['elb_home']

  bash 'unzip_elb_tools' do
    code <<EOF
unzip -d "#{elb_home}" "#{elb_zipfile}" && f=("#{elb_home}"/*) && \
mv "#{elb_home}"/*/* ""#{elb_home}"" && rmdir "${f[@]}"
EOF
    action :nothing
  end

  remote_file "#{elb_zipfile}" do
    source 'http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip'
    not_if {::File.exist?(::File.join(elb_home,'bin'))}
    notifies :run, 'bash[unzip_elb_tools]', :immediately
  end
end

action :attach do
  elb_home = node['cloud_lb_service']['elb_home']
  cred_file = ::File.join(Chef::Config[:file_cache_path],'elb')
  region = node['ec2']['placement_availability_zone']
    .match(/[a-z]{2}-[a-z]*-[0-9]*/)
  instance = node['ec2']['instance_id']

  template cred_file do
    source 'elb_credentials.erb'
    mode 00600
    variables(
      aws_access_key: new_resource.username,
      aws_secret_key: new_resource.password
    )
  end

  # Java home might be empty when run in Chef Solo, something to look out for.
  execute 'elb-register-instances-with-lb' do
    command <<EOF
#{::File.join(elb_home,'bin','elb-register-instances-with-lb')} \
#{new_resource.load_balancer} --instances #{instance}
EOF
    environment(
      'AWS_ELB_HOME' => elb_home,
      'AWS_CREDENTIAL_FILE' => cred_file,
      'AWS_ELB_URL' => "https://elasticloadbalancing.#{region}.amazonaws.com",
      'JAVA_HOME' => node['java']['java_home']
    )
  end

  file cred_file do
    action :delete
  end
end

action :detach do
  elb_home = node['cloud_lb_service']['elb_home']
  cred_file = ::File.join(Chef::Config[:file_cache_path],'elb')
  region = node['ec2']['placement_availability_zone']
  .match(/[a-z]{2}-[a-z]*-[0-9]*/)
  instance = node['ec2']['instance_id']

  template cred_file do
    source 'elb_credentials.erb'
    mode 00600
    variables(
        aws_access_key: new_resource.username,
        aws_secret_key: new_resource.password
    )
  end

  # Java home might be empty when run in Chef Solo, something to look out for.
  execute 'elb-register-instances-with-lb' do
    command <<EOF
#{::File.join(elb_home,'bin','elb-deregister-instances-from-lb')} \
#{new_resource.load_balancer} --instances #{instance}
EOF
    environment(
        'AWS_ELB_HOME' => elb_home,
        'AWS_CREDENTIAL_FILE' => cred_file,
        'AWS_ELB_URL' => "https://elasticloadbalancing.#{region}.amazonaws.com",
        'JAVA_HOME' => node['java']['java_home']
    )
  end

  file cred_file do
    action :delete
  end
end