# Encoding: utf-8
name             'rax-ruby-app'
maintainer       'Rackspace'
maintainer_email 'jason.boyles@rackspace.com'
license          'Apache 2.0'
description      'Installs/Configures rax-ruby-app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apt', '~> 2.4.0'
depends 'build-essential'
depends 'chruby'
depends 'rvm', '~> 0.9.2'
depends 'mysql'
depends 'mysql-chef_gem'
depends 'postgresql'
depends 'application'
depends 'database'
depends 'sudo', '~> 2.6.0'
