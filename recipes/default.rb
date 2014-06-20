# Encoding: utf-8
#
# Cookbook Name:: rax-ruby-app
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt::default'
include_recipe 'build-essential::default'

if node[:rax_ruby_app][:app_server] == 'passenger'
  node.set[:rax_ruby_app][:web][:server] = 'apache'
end

user node[:rax_ruby_app][:user] do
  supports manage_home: true
  comment 'Rails user'
  home node[:rax_ruby_app][:user_home]
  shell '/bin/bash'
  system true
end

group node[:rax_ruby_app][:group]

group node[:rax_ruby_app][:group] do
  members node[:rax_ruby_app][:user]
  append true
  action :modify
end

sudo node[:rax_ruby_app][:user] do
  nopasswd true
  user node[:rax_ruby_app][:user]
end

include_recipe 'rax-ruby-app::database'

include_recipe "rax-ruby-app::_ruby_#{node[:rax_ruby_app][:ruby_install_type]}"

include_recipe 'rax-ruby-app::deploy_config_app'

include_recipe "rax-ruby-app::_app_server_#{node[:rax_ruby_app][:app_server]}"

include_recipe "rax-ruby-app::_web_#{node[:rax_ruby_app][:web][:server]}"
