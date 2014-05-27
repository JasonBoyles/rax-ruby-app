# Encoding: utf-8

node.set[:postgresql][:password][:postgres] = node[:rax_ruby_app][:db_admin_password]
include_recipe 'postgresql::server'
