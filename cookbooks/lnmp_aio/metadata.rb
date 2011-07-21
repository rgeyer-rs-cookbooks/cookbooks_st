maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Installs/Configures lnmp_aio"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "phpmyadmin"
depends "nginx"

recipe "default","Installs an SSL vhost in NGINX and puts some software (like phpmyadmin) in it."