# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.network "forwarded_port", guest: 3000, host: 8181,
    auto_correct: true
  config.vm.network "forwarded_port", guest: 80, host: 8383,
    auto_correct: true
  config.vm.network "forwarded_port", guest: 8080, host: 8282,
    auto_correct: true
  config.vm.hostname = 'rax-ruby-app'
  config.vm.box = 'ubuntu-12.04'
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{config.vm.box}_chef-provisionerless.box"
  config.omnibus.chef_version = 'latest'
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    # chef.log_level = "debug"
    chef.json = {
        :rax_ruby_app => {
          :additional_packages => 'libpq-dev',
          :db => {
            :type => "postgresql",
            :install_service => "true",
            :admin_password => "averybadpassword",
            :user_id => "rails",
            :user_password => "averybadpassword"
          },
          :web => {
            :server => 'nginx'
          },
          :ruby_version => "1.9.3-p392",
          # :ruby_version => "2.1.2",
          :ruby_install_type => "chruby",
          :git_url => 'https://github.com/JasonBoyles/railsapp.git',
          # :git_url => 'https://github.com/rackerlabs/multi-cloud-demo-app.git',
          # :git_url => 'https://github.com/JasonBoyles/kandan.git',
          # :git_url => 'https://github.com/kandanapp/kandan.git',
          # :git_url => 'https://github.com/railstutorial/sample_app.git',
          :git_revision => 'master',
          :app_server => 'unicorn',
          :rails => {
            :db_adapter => 'postgresql',
            :rake_tasks => 'db:migrate assets:precompile'
            # :rake_tasks => 'db:migrate assets:precompile kandan:bootstrap'
          }
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
