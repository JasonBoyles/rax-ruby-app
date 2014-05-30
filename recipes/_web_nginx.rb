# Encoding: utf-8

node.set['nginx']['default_site_enabled'] = false

include_recipe 'nginx'

template File.join(node['nginx']['dir'], 'sites-available', 'rails') do
  source 'nginx-site.erb'
  owner 'root'
  group 'root'
  mode 0644
end

nginx_site 'rails' do
  template nil
  notifies :reload, resources(service: 'nginx')
end
