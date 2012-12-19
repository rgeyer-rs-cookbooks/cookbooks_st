maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "All rights reserved"
description      "Installs/Configures cloudstack_single_node"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "db", "~> 13.2"
depends "db_mysql", "~> 13.2"
depends "rightscale", "~> 13.2"

recipe "cloudstack_single_node::default", "Moves the database files to the mounted directory"