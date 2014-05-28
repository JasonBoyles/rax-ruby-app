# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.network "forwarded_port", guest: 3000, host: 8181,
    auto_correct: true
  config.vm.hostname = 'rax-ruby-app'
  config.vm.box = 'ubuntu-12.04'
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{config.vm.box}_chef-provisionerless.box"
  config.omnibus.chef_version = 'latest'
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
        :rax_ruby_app => {
          :db => {
            :type => "postgres",
            :install_service => "true",
            :admin_password => "averybadpassword",
            :user_id => "rails",
            :user_password => "averybadpassword"
          },
          :ruby_version => "1.9.3-p392",
          :ruby_install_type => "chruby",
          :git_url => 'https://github.com/kandanapp/kandan.git',
          :git_revision => 'v1.2'
        },
        :mysql => {
          :remove_anonymous_users => true,
          :remove_test_database => true,
          :server_debian_password => 'averydebpassword',
          :server_repl_password => 'averyreplpassword'
        }
    }

    chef.run_list = [
        'recipe[rax-ruby-app::default]'
    ]
  end
end
