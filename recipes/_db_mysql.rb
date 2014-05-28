# Encoding: utf-8

node.set[:mysql][:server_root_password] =
                                      node[:rax_ruby_app][:db][:admin_password]
include_recipe 'mysql::server'
