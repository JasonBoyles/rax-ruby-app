# configure unicorn application server

bash 'install unicorn gem' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/gem install unicorn
  EOH
end

rails_app_dir = File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current')

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

node.set['unicorn-ng']['config']['config_file'] = File.join(
    node[:rax_ruby_app][:user_home], 'rails_app', 'current', 'config',
    'unicorn.rb')
node.set['unicorn-ng']['service']['rails_root'] = File.join(
    node[:rax_ruby_app][:user_home], 'rails_app', 'current')
node.set['unicorn-ng']['config']['worker_processes'] = 10
node.set['unicorn-ng']['service']['user'] = node[:rax_ruby_app][:user]
node.set['unicorn-ng']['service']['environment'] = node[:rax_ruby_app][:rails][:environment]
node.set['unicorn-ng']['config']['listen'] = 'unix:tmp/sockets/unicorn.sock'
node.override['unicorn-ng']['service']['bundle'] = '/opt/rubies/1.9.3-p392/bin/bundle'

log "bundle path is #{node['unicorn-ng']['service']['bundle']}" do
  level :info
end

directory File.join(rails_app_dir, 'tmp', 'pids') do
  owner node[:rax_ruby_app][:user]
  group node[:rax_ruby_app][:group]
  recursive true
  action :create
end

directory File.join(rails_app_dir, 'tmp', 'sockets') do
  owner node[:rax_ruby_app][:user]
  group node[:rax_ruby_app][:group]
  recursive true
  action :create
end

directory File.join(rails_app_dir, 'log') do
  owner node[:rax_ruby_app][:user]
  group node[:rax_ruby_app][:group]
  recursive true
  action :create
end

unicorn_ng_config File.join(node[:rax_ruby_app][:user_home],
                   'rails_app', 'current',
                   'config', 'unicorn.rb') do
    user 'rails'
    working_directory File.join(node[:rax_ruby_app][:user_home], 'rails_app',
                                 'current')
    listen  'unix:tmp/sockets/unicorn.sock'
    backlog 1024
end

unicorn_ng_service File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current') do
    bundle node['unicorn-ng']['service']['bundle']
    environment node[:rax_ruby_app][:rails][:environment]
end
