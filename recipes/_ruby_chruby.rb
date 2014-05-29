# Encoding: utf-8

node.set[:chruby][:rubies] = { node[:rax_ruby_app][:ruby_version] => true }
node.set[:chruby][:default] = node[:rax_ruby_app][:ruby_version]

include_recipe 'chruby::system'

bash 'install bundler' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  sudo /opt/rubies/#{node[:rax_ruby_app][:ruby_version]}/bin/gem install bundler
  EOH
end
