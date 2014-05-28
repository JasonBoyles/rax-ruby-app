# Encoding: utf-8
default[:rax_ruby_app][:user] = 'rails'
default[:rax_ruby_app][:group] = node[:rax_ruby_app][:user]
default[:rax_ruby_app][:user_home] = File.join('/home',
                                               node[:rax_ruby_app][:user])

default[:rax_ruby_app][:db][:type] = 'postgres'
default[:rax_ruby_app][:db][:install_service] = true
default[:rax_ruby_app][:db][:admin_password] = nil
default[:rax_ruby_app][:db][:user_id] = node[:rax_ruby_app][:user]
default[:rax_ruby_app][:db][:user_password] = nil

default[:rax_ruby_app][:app_server] = 'unicorn'
default[:rax_ruby_app][:unicorn][:port] = 8080
default[:rax_ruby_app][:unicorn][:worker_processes] = 3
