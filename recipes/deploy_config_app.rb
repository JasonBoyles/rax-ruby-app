# Encoding: utf-8

commonly_required_packages = [
  'nodejs',                  # js execution environment for the execjs gem
  'libmysqlclient-dev',      # MySQL client lib for the mysql2 gem
  'libmagickwand-dev',       # rmagick uses this for image manipulation
  'libicu-dev'               # unicode string handling for charlock-holmes
]

pkgs_to_install = node[:rax_ruby_app][:additional_packages].split()
pkgs_to_install = pkgs_to_install.concat(commonly_required_packages)

pkgs_to_install.each do |pkg|
  package pkg do
    action :install
  end
end

application 'app' do
  path File.join(node[:rax_ruby_app][:user_home], 'rails_app')
  owner node[:rax_ruby_app][:user]
  group node[:rax_ruby_app][:group]
  repository node[:rax_ruby_app][:git_url]
  revision node[:rax_ruby_app][:git_revision]
end

bash 'bundle install in application directory' do
  user node[:rax_ruby_app][:user]
  group node[:rax_ruby_app][:group]
  cwd File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current')
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/bundle install --deployment
  EOH
end

template File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current',
                   'config', 'database.yml') do
  source 'database.yml.erb'
  owner node[:rax_ruby_app][:user]
  group node[:rax_ruby_app][:group]
  mode 0660
  variables(
    database_type: node[:rax_ruby_app][:db][:type],
    database_hostname: node[:rax_ruby_app][:db][:hostname],
    app_database_name: node[:rax_ruby_app][:db][:name],
    rails_app_db_username: node[:rax_ruby_app][:db][:user_id],
    rails_app_db_password: node[:rax_ruby_app][:db][:user_password]
  )
end

node[:rax_ruby_app][:rails][:rake_tasks].split.each do |task|
  bash "do rake task #{task}" do
    user node[:rax_ruby_app][:user]
    cwd File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current')
    environment "RAILS_ENV" => node[:rax_ruby_app][:rails][:environment]
    code <<-EOH
    /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/bundle exec rake #{task}
    EOH
  end
end
