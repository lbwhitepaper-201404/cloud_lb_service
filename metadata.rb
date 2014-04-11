# encoding: UTF-8
name             'cloud_lb_service'
maintainer       'Ryan J. Geyer'
maintainer_email 'me@ryangeyer.com'
license          'All rights reserved'
description      'Installs/Configures cloud_lb_service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w(marker java apt rightscale_tag ohai-private-ipaddress).each do |d|
  depends d
end

%w(rsc_google_cloud google_cloud).each do |r|
  recommends r
end

recipe 'cloud_lb_service::default', 'installs necessary CLI tools and dependencies.'
recipe 'cloud_lb_service::attach', 'Attaches this node to the specified load balancer'
recipe 'cloud_lb_service::detach', 'Detaches this node from the specified load balancer'

attribute 'cloud_lb_service/type',
          display_name: 'Cloud Load Balancer Type',
          choice: ['rs_haproxy','clb','elb'],
          default: 'rs_haproxy'

attribute 'cloud_lb_service/load_balancer',
          display_name: 'Cloud Load Balancer Name',
          required: 'required'

attribute 'cloud_lb_service/username',
          display_name: 'Cloud Load Balancer Username'

attribute 'cloud_lb_service/password',
          display_name: 'Cloud Load Balancer Password'
