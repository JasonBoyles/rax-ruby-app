# Encoding: utf-8

node.set[:chruby][:rubies] = { node[:rax_ruby_app][:ruby_version] => true }
node.set[:chruby][:default] = node[:rax_ruby_app][:ruby_version]

include_recipe 'chruby::system'

node.set[:rax_ruby_app][:ruby_bin_dir] = File.join(
  'opt', 'rubies', node[:rax_ruby_app][:ruby_version]}, 'bin')

bash 'install bundler' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  sudo #{File.join(node[:rax_ruby_app][:ruby_bin_dir], 'gem')} install bundler
  EOH
end
