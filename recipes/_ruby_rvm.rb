# Encoding: utf-8

node.set[:rvm][:user_installs] = [
  {
    user: node[:rax_ruby_app][:user],
    install_rubies: true,
    default_ruby: node[:rax_ruby_app][:ruby_version],
    user_rubies: [node[:rax_ruby_app][:ruby_version]]
  }
]

include_recipe 'rvm::user'
