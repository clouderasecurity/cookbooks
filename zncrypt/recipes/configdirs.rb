#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Recipe:: configdirs
#
# Copyright 2012, Gazzang, Inc.
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
#

# pull the directory configuration from the data bags
zncrypt_mount = node['zncrypt']['zncrypt_mount']
zncrypt_storage = node['zncrypt']['zncrypt_storage']
config_dirs = "-m #{zncrypt_mount} -s #{zncrypt_storage }"
case node['platform_family']
when "rhel","fedora"
 opt = '-l'
when "debian"
 opt = '-a'
end

script "config dirs" do
 interpreter "bash"
 user "root"
 code <<-EOH
 ezncrypt-service stop
 ezncrypt-configure-directories #{config_dirs} #{opt}
 EOH
end
