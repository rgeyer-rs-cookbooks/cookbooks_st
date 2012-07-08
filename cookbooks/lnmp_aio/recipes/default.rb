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
# node[:app_wordpress][:version_store_path] = ::File.join(mountpoint, "wordpress-home", "versions")

node[:db_mysql][:datadir] = ::File.join(mountpoint, "mysql")

directory node[:db_mysql][:datadir] do
  action :create
end

if node[:platform] == "ubuntu"
  node[:php5][:module_list] += " curl" unless node[:php5][:module_list] =~ /curl/
  node[:php5][:module_list] += " fileinfo" unless node[:php5][:module_list] =~ /fileinfo/
end

rightscale_marker :end