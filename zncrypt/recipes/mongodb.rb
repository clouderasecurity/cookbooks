#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Recipe:: mongodb
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

# setup the proper 10gen repositories for the distro
case node['platform_family']
when "rhel","fedora"
 # use the yum cookbook
 include_recipe "yum::yum"
 # Add the 10gen repo, redhat centos fedora
 yum_repository "10gen" do
  repo_name "10gen"
  description "10gen Repository"
  url "http://downloads-distro.mongodb.org/repo/redhat/os/x86_64"
  action :add
 end
when "debian"
 # use the apt cookbook
 include_recipe "apt::default"
 # Add the 10gen repo, ubuntu debian
 apt_repository "10gen" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  distribution "dist"
  components ["10gen"]
  key "http://docs.mongodb.org/10gen-gpg-key.asc"
  action :add
  notifies :run, resources(:execute => "apt-get update"), :immediately
 end
else
  Chef::Application.fatal!("Your distro is not yet supported/tested, patches welcome!")
end


# assemble the packages
mongo_packages = case node['platform_family']
when "rhel","fedora"
 data_dir="/var/lib/mongo"
 service_name="mongod"
 include_recipe "yum::yum"
 %w{mongo-10gen mongo-10gen-server}
when "debian"
 data_dir="/var/lib/mongodb"
 service_name="mongodb"
 %w{mongodb-10gen}
end


# loop to install packages
mongo_packages.each do |mongo_pack|
  package mongo_pack do
    action :install
  end
end

# Mongo is installed, we proceed to set up the encryption
# the path here is hardcoded, if it does not match yours edit here
acl_rule1="/usr/bin/mongod"
acl_rule2="/bin/mkdir"

passphrase = node['zncrypt']['passphrase']
passphrase2 = node['zncrypt']['passphrase2']
if passphrase.nil?
 # check if there is a masterkey_bag otherwise skip activation
 data_bag('masterkey_bag')
 # we also need a passhprase and second passphrase, we will generate a random one
 passphrase=data_bag_item('masterkey_bag', 'key1')['passphrase']
 passphrase2=data_bag_item('masterkey_bag', 'key1')['passphrase2']
end
zncrypt_mount = node['zncrypt']['zncrypt_mount']
script "create ACL" do
 interpreter "bash"
 user "root"
 cwd "/tmp"
 code <<-EOH
 service #{service_name} stop
 printf "#{passphrase}\n#{passphrase2}\n" | zncrypt acl --add --rule="ALLOW @mongodb * #{acl_rule1}"
 printf "#{passphrase}\n#{passphrase2}\n" | zncrypt acl --add --rule="ALLOW @mongodb * #{acl_rule2}"
 printf "#{passphrase}\n#{passphrase2}\n" | zncrypt-move encrypt @mongodb #{data_dir} #{zncrypt_mount}
 service #{service_name} start
 EOH
end
