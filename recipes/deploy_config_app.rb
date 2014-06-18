# Encoding: utf-8

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
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/bundle install
  EOH
end

bash 'install ref & therubyracer gems' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/gem install ref
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/gem install therubyracer
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
