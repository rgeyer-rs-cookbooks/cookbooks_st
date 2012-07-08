maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "Apache 2.0" #IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Installs/Configures lnmp_aio"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{phpmyadmin nginx php5 perl rightscale mail_postfix app_wordpress db_mysql}.each do |d|
  depends d
end

recipe "lnmp_aio::default","Sets up some variables, and overwrites some node attributes"
recipe "lnmp_aio::setup_lnmp_aio","Installs an SSL vhost in nginx and puts some software (like phpmyadmin) in it."

attribute "lnmp_aio/web/hostname",
  :display_name => "Web Server Hostname",
  :description => "The fully qualified domain name where some useful tools will be deployed.",
  :required => "required",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

# Nginx duplicates
attribute "nginx/dir",
  :display_name => "Nginx Directory",
  :description => "Location of nginx configuration files",
  :default => "/etc/nginx",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/content_dir",
  :display_name => "Nginx Content Directory",
  :description => "Location of nginx content files",
  :default => "/var/www",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/log_dir",
  :display_name => "Nginx Log Directory",
  :description => "Location for nginx logs",
  :default => "/var/log/nginx",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/binary",
  :display_name => "Nginx Binary",
  :description => "Location of the nginx server binary",
  :default => "/usr/sbin/nginx",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/gzip",
  :display_name => "Nginx Gzip",
  :description => "Whether gzip is enabled",
  :default => "on",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/gzip_http_version",
  :display_name => "Nginx Gzip HTTP Version",
  :description => "Version of HTTP Gzip",
  :default => "1.0",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/gzip_comp_level",
  :display_name => "Nginx Gzip Compression Level",
  :description => "Amount of compression to use",
  :default => "2",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/gzip_proxied",
  :display_name => "Nginx Gzip Proxied",
  :description => "Whether gzip is proxied",
  :default => "any",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/gzip_types",
  :display_name => "Nginx Gzip Types",
  :description => "Supported MIME-types for gzip",
  :type => "array",
  :default => [ "text/plain", "text/html", "text/css", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript" ],
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/keepalive",
  :display_name => "Nginx Keepalive",
  :description => "Whether to enable keepalive",
  :default => "on",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/keepalive_timeout",
  :display_name => "Nginx Keepalive Timeout",
  :default => "65",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/worker_processes",
  :display_name => "Nginx Worker Processes",
  :description => "Number of worker processes",
  :default => "1",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/worker_connections",
  :display_name => "Nginx Worker Connections",
  :description => "Number of connections per worker",
  :default => "1024",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "nginx/server_names_hash_bucket_size",
  :display_name => "Nginx Server Names Hash Bucket Size",
  :default => "64",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

# PHP duplicates
attribute "php5/module_list",
  :display_name => "PHP5 Module List",
  :description => "A list of PHP5 modules to install, separated by spaces. Only supply the module name appearing after php5-.  For instance if you wanted php5-mysql and php5-imap installed, this list should be set to \"mysql imap\".  To view a full list of available php5 modules see the Ubuntu package page http://packages.ubuntu.com/search?searchon=names&keywords=php5- ",
  :default => "",
  :recipes => ["lnmp_aio::setup_lnmp_aio"],
  :type => "string"

attribute "php5/server_usage",
  :display_name => "Server Usage",
  :description => "* dedicated (where the php-fpm config file allocates all existing resources of the machine)\n* shared (where the php-fpm config file is configured to use less resources so that it can be run concurrently with other apps like MySQL for example)",
  :recipes => ["lnmp_aio::setup_lnmp_aio"],
  :choice => ["shared", "dedicated"],
  :default => "dedicated"

attribute "php5/listen",
  :display_name => "PHP5 FPM Listen Method",
  :description => "The listening method, one of [socket, tcp].  If socket is selected, php5/listen_socket can optionally be supplied.  If tcp is selected, php5/listen_ip and php5/listen_port can optionally be supplied",
  :recipes => ["lnmp_aio::setup_lnmp_aio"],
  :choice => ["socket", "tcp"],
  :default => "socket"

attribute "php5/listen_socket",
  :display_name => "PHP5 FPM Listen Socket",
  :description => "The full path and filename of the unix socket to listen on",
  :recipes => ["lnmp_aio::setup_lnmp_aio"],
  :required => "optional",
  :default => "/var/run/php5-fpm.sock"

attribute "php5/listen_ip",
  :display_name => "PHP5 FPM Listen IP",
  :description => "The TCP/IP address for PHP-FPM to listen on",
  :recipes => ["lnmp_aio::setup_lnmp_aio"],
  :required => "optional",
  :default => "127.0.0.1"

attribute "php5/listen_port",
  :display_name => "PHP5 FPM Listen",
  :description => "The TCP/IP address for PHP-FPM to listen on",
  :recipes => ["lnmp_aio::setup_lnmp_aio"],
  :required => "optional",
  :default => "9000"

# Postfix duplicates
attribute "mail_postfix/db_user",
  :display_name => "Postfix MySQL Database Username",
  :description => "The username to access the postfix configuration database in MySQL",
  :default => "postfix",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "mail_postfix/db_pass",
  :display_name => "Postfix MySQL Database Password",
  :description => "The password to access the postfix configuration database in MySQL",
  :required => true,
  :recipes => ["lnmp_aio::setup_lnmp_aio"]

attribute "mail_postfix/db_name",
  :display_name => "Postfix MySQL Database Name",
  :description => "The name of the postfix configuration database in MySQL",
  :default => "postfix",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]


attribute "mail_postfix/db_host",
  :display_name => "Postfix MySQL Database Host",
  :description => "The hostname of the postfix configuration MySQL database server",
  :default => "localhost",
  :recipes => ["lnmp_aio::setup_lnmp_aio"]