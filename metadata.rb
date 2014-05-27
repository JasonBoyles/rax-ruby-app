# Encoding: utf-8
name             'rax-ruby-app'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'jason.boyles@rackspace.com'
license          'Apache 2.0'
description      'Installs/Configures rax-ruby-app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apt"
depends "build-essential"
depends "postgresql"
depends "chruby"
depends "mysql"
depends "application"
depends "database"

