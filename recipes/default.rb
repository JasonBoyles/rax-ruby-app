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

group node[:rax_ruby_app][:group]

user node[:rax_ruby_app][:user] do
  supports :manage_home => true
  comment "Rails user"
  home node[:rax_ruby_app][:user_home]
  shell '/bin/bash'
  system true
end

group 'sudo' do
  action :modify
  members node[:rax_ruby_app][:user]
  append true
end

if node[:rax_ruby_app][:db][:install_service]
  include_recipe "rax-ruby-app::_db_#{node[:rax_ruby_app][:db][:type]}"
end

if node[:rax_ruby_app][:ruby_install_type] == 'chruby'
  node.set[:chruby][:rubies] = { "#{node[:rax_ruby_app][:ruby_version]}" => true}
  node.set[:chruby][:default] = node[:rax_ruby_app][:ruby_version]
  include_recipe 'chruby::system'
  bash "install bundler" do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    sudo /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/gem install bundler
    EOH
  end
elsif node[:rax_ruby_app][:ruby_install_type] == 'rvm'
  #do rvm stuff
end

application 'app' do
  path File.join(node[:rax_ruby_app][:user_home], 'rails_app')
  owner node[:rax_ruby_app][:user]
  group node[:rax_ruby_app][:group]
  repository node[:rax_ruby_app][:git_url]
  revision node[:rax_ruby_app][:git_revision]
end

bash "bundle install in application directory" do
  user node[:rax_ruby_app][:user]
  group 'sudo'
  cwd File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current')
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/bundle install
  EOH
end

bash 'install ref & therubyracer' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/gem install ref
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/gem install therubyracer
  EOH
end
