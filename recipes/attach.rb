# encoding: UTF-8
#
# Cookbook Name:: cloud_lb_service
# Recipe:: attach
#
# Copyright 2014, Ryan J. Geyer <me@ryangeyer.com>
#
# All rights reserved - Do Not Redistribute
#

marker 'recipe_start_rightscale' do
  template 'rightscale_audit_entry.erb'
end

cloud_lb_service 'Load Balancer' do
  provider "cloud_lb_service_#{node['cloud_lb_service']['type']}"
  load_balancer node['cloud_lb_service']['load_balancer']
  username node['cloud_lb_service']['username']
  password node['cloud_lb_service']['password']

  # Specific to HAProxy, which makes this a bad abstraction IMHO
  listen_ip ::OhaiPrivateIpaddress::Helper.ip(node)
  listen_port '80' # Should be a variable, but a node attribute makes it just as hardcoded
  vhost_path '/'
  action :attach
end
