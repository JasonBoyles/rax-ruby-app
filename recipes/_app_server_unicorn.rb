# configure unicorn application server

bash 'install unicorn gem' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/gem install unicorn
  EOH
end

rails_app_dir = File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current')

node.set['unicorn-ng']['config']['config_file'] = File.join(
    rails_app_dir, 'config', 'unicorn.rb')
node.set['unicorn-ng']['service']['rails_root'] = rails_app_dir
node.set['unicorn-ng']['config']['worker_processes'] = 10
node.set['unicorn-ng']['service']['user'] = node[:rax_ruby_app][:user]
node.set['unicorn-ng']['service']['environment'] = node[:rax_ruby_app][:rails][:environment]
node.set['unicorn-ng']['config']['listen'] = 'unix:tmp/sockets/unicorn.sock'
node.override['unicorn-ng']['service']['bundle'] = '/opt/rubies/1.9.3-p392/bin/bundle'
node.set[:rax_ruby_app][:socket_path] = File.join(rails_app_dir,
    node['unicorn-ng']['config']['listen'])

log "bundle path is #{node['unicorn-ng']['service']['bundle']}" do
  level :info
end

%w{tmp tmp/pids tmp/sockets log}.each do |d|
  directory File.join(rails_app_dir, d) do
    owner node[:rax_ruby_app][:user]
    group node[:rax_ruby_app][:group]
    action :create
  end
end

unicorn_ng_config File.join(rails_app_dir, 'config', 'unicorn.rb') do
    user node[:rax_ruby_app][:user]
    working_directory rails_app_dir
    listen  'unix:tmp/sockets/unicorn.sock'
    backlog 1024
end

unicorn_ng_service rails_app_dir do
    user node[:rax_ruby_app][:user]
    bundle File.join(node[:rax_ruby_app][:ruby_bin_dir], 'bundle')
    environment node[:rax_ruby_app][:rails][:environment]
end
