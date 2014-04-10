# encoding: UTF-8
node.default['cloud_lb_service']['elb_home'] = '/opt/elb'
node.default['cloud_lb_service']['type'] = 'rs_haproxy'
node.default['cloud_lb_service']['terminate_on_detach']=false