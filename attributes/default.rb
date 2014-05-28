# Encoding: utf-8
default[:rax_ruby_app][:user] = 'rails'
default[:rax_ruby_app][:group] = 'rails'
default[:rax_ruby_app][:user_home] = File.join('/home',
                                               node[:rax_ruby_app][:user])

default[:rax_ruby_app][:db][:type] = 'postgres'
default[:rax_ruby_app][:db][:install_service] = true
