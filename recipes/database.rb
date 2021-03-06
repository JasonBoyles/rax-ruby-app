# Encoding: utf-8

include_recipe 'apt::default'
include_recipe 'build-essential::default'

case node[:rax_ruby_app][:db][:type]
when 'mysql'
  include_recipe 'mysql-chef_gem'
when 'postgresql'
  include_recipe 'postgresql::ruby'
end

if node[:rax_ruby_app][:db][:install_service]
  include_recipe "rax-ruby-app::_db_#{node[:rax_ruby_app][:db][:type]}"

  case node[:rax_ruby_app][:db][:type]
  when 'mysql'
    username = 'root'
    port = node['mysql']['port'].to_i
    provider = Chef::Provider::Database::Mysql
    user_provider = Chef::Provider::Database::MysqlUser
    db_privileges = [:index, :create, :select, :update, :insert]
  when 'postgresql'
    username = 'postgres'
    port = node['postgresql']['config']['port']
    provider = Chef::Provider::Database::Postgresql
    user_provider = Chef::Provider::Database::PostgresqlUser
    db_privileges = [:all]
  end

  db_connection_info = {
    host: node[:rax_ruby_app][:db][:hostname],
    username: username,
    port: port,
    password: node[:rax_ruby_app][:db][:admin_password]
  }

  database node[:rax_ruby_app][:db][:name] do
    connection db_connection_info
    provider provider
    action :create
  end

  database_user node[:rax_ruby_app][:db][:user_id] do
    connection db_connection_info
    password node[:rax_ruby_app][:db][:user_password]
    provider user_provider
    action :create
  end

  database_user node[:rax_ruby_app][:db][:user_id] do
    connection db_connection_info
    provider user_provider
    database_name node[:rax_ruby_app][:db][:name]
    host node[:rax_ruby_app][:db][:acl]
    privileges db_privileges
    action :grant
  end
end
