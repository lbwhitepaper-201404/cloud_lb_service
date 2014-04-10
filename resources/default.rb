# encoding: UTF-8

attribute :load_balancer, :kind_of => String, :regex => [/^\w/]

attribute :username, :kind_of => String

attribute :password

attribute :listen_ip, :kind_of => String

attribute :listen_port, :kind_of => String

attribute :vhost_path, :kind_of => String

actions :install

actions :attach

actions :detach

default_action :install