

application 'app' do
  path File.join(node[:rax_ruby_app][:user_home], 'rails_app')
  owner node[:rax_ruby_app][:user]
  group node[:rax_ruby_app][:group]
  repository node[:rax_ruby_app][:git_url]
  revision node[:rax_ruby_app][:git_revision]
end

bash "bundle install in application directory" do
  user node[:rax_ruby_app][:user]
  group 'sudo'
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

bash 'initialize app database' do
  user node[:rax_ruby_app][:user]
  cwd File.join(node[:rax_ruby_app][:user_home], 'rails_app', 'current')
  code <<-EOH
  /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/bundle exec rake db:migrate
  EOH
end

