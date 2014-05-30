# Encoding: utf-8
default[:rax_ruby_app][:user] = 'rails'
default[:rax_ruby_app][:group] = node[:rax_ruby_app][:user]
default[:rax_ruby_app][:user_home] = File.join('/home',
                                               node[:rax_ruby_app][:user])
default[:rax_ruby_app][:ruby_version] = '1.9.3-p392'

# Database settings
default[:rax_ruby_app][:db][:type] = 'postgres'
default[:rax_ruby_app][:db][:install_service] = true
default[:rax_ruby_app][:db][:admin_password] = nil
default[:rax_ruby_app][:db][:user_id] = node[:rax_ruby_app][:user]
default[:rax_ruby_app][:db][:user_password] = 'uShouldChangeMe'
default[:rax_ruby_app][:db][:name] = 'railsapp'
default[:rax_ruby_app][:db][:acl] = '%'

default[:rax_ruby_app][:app_server] = 'unicorn'

default[:rax_ruby_app][:rails][:environment] = 'production'

default[:rax_ruby_app][:unicorn][:port] = 8080
default[:rax_ruby_app][:unicorn][:worker_processes] = 3

# Webserver Settings
default[:rax_ruby_app][:web][:server] = 'nginx'
