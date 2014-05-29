# configure unicorn application server

bash 'install unicorn gem' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/gem install unicorn
  EOH
end

template File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current',
                   'config', 'unicorn.rb') do
  source 'unicorn.rb.erb'
  owner node[:rax_ruby_app][:user]
  group node[:rax_ruby_app][:group]
  mode 0660
  variables(
    working_directory: File.join(node[:rax_ruby_app][:user_home], 'rails_app',
                                 'current'),
    listen_port: node[:rax_ruby_app][:unicorn][:port],
    worker_processes: node[:rax_ruby_app][:unicorn][:worker_processes],
    pid: File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current',
                   'unicorn.pid'),
    user: node[:rax_ruby_app][:user],
    group: node[:rax_ruby_app][:group],
    stderr: File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current',
                      'unicorn_stderr.log'),
    stdout: File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current',
                      'unicorn_stdout.log')
  )
end
