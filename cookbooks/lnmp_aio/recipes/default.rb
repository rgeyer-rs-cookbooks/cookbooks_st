#
# Cookbook Name:: lnmp_aio
# Recipe:: default
#
# Copyright 2011-2012, Ryan J. Geyer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

rightscale_marker :begin

# Preset some things that are in external cookbooks
# TODO: Should have the storage mountpoint be a variable or input somewhere
mountpoint = "/mnt/storage"
node[:app_wordpress][:version_store_path] = ::File.join(mountpoint, "wordpress-home", "versions")

node[:db_mysql][:datadir] = ::File.join(mountpoint, "mysql")

if node[:platform] == "ubuntu"
  node[:php5][:module_list] += " curl" unless node[:php5][:module_list] =~ /curl/
  node[:php5][:module_list] += " fileinfo" unless node[:php5][:module_list] =~ /fileinfo/
end

include_recipe "nginx::install_from_package"
include_recipe "nginx::setup_stats"
include_recipe "php5::install_php"
include_recipe "php5::install_fpm"
include_recipe "php5::setup_fpm_nginx"
include_recipe "php5::setup_fpmstats_nginx"
include_recipe "mail_postfix::setup_postfix"
include_recipe "perl::default"

nginx_ssl_dir = "#{node[:nginx][:dir]}/ssl"
fqdn = node[:lnmp_aio][:web][:hostname]
nginx_htdocs = ::File.join(node[:nginx][:content_dir], fqdn, 'htdocs')
phpadmin_home = ::File.join(nginx_htdocs, 'phpmyadmin')

directory nginx_ssl_dir do
  mode 0644
  owner "root"
  group "root"
  recursive true
  action :create
end

bash "Create SSL Certificates" do
  cwd nginx_ssl_dir
  code <<-EOH
  umask 077
  openssl genrsa 2048 > #{fqdn}.key
  openssl req -subj '/CN=#{fqdn}' -new -x509 -nodes -sha1 -days 3650 -key #{fqdn}.key > #{fqdn}.crt
  cat #{fqdn}.key #{fqdn}.crt > #{fqdn}.pem
  EOH
  not_if { ::File.exists?(::File.join(nginx_ssl_dir, "#{fqdn}.pem")) }
end

nginx_enable_vhost fqdn do
  cookbook "lnmp_aio"
  template "nginx-ssl-vhost.conf.erb"
  fqdn fqdn
end

phpmyadmin_instance phpadmin_home do
  home phpadmin_home
  user node[:nginx][:user]
  action :create
end

# TODO: Restart the php-fpm app server to account for the mcrypt installation

rightscale_marker :end