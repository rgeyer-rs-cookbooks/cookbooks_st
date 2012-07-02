maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "Apache 2.0" #IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Installs/Configures lnmp_aio"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{phpmyadmin nginx php5 perl rightscale}.each do |d|
  depends d
end

recipe "lnmp_aio::default","Installs an SSL vhost in nginx and puts some software (like phpmyadmin) in it."

attribute "lnmp_aio/web/hostname",
  :display_name => "Web Server Hostname",
  :description => "The fully qualified domain name where some useful tools will be deployed.",
  :required => "required",
  :recipes => ["lnmp_aio::default"]