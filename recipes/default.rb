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

user "rails" do
  supports :manage_home => true
  comment "Rails user"
  home "/home/rails"
  shell "/bin/bash"
  system true
end

group "sudo" do
  action :modify
  members "rails"
  append true
end

if node[:rax_ruby_app][:db_type] == 'postgres'
  node.set[:postgresql][:password][:postgres] = node[:rax_ruby_app][:db_admin_password]
  include_recipe 'postgresql::server'
elsif node[:rax_ruby_app][:db_type] == 'mysql'
  #do mysql stuff
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

application "app" do
  path '/home/rails/rails_app'
  owner 'rails'
  group 'rails'
  repository node[:rax_ruby_app][:git_url]
  revision node[:rax_ruby_app][:git_revision]
end

bash "bundle install in application directory" do
  user 'rails'
  cwd '/home/rails/rails_app/current'
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/bundle install
  EOH
end

bash "install ref & therubyracer" do
  user 'rails'
  cwd '/home/rails/rails_app/current'
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/bundler exec gem install ref
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/bundler exec gem install therubyracer
  EOH
end
