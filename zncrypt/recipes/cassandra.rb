#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Recipe:: cassandra
#
# Copyright 2012, Gazzang, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
#begin
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

# include the java and python recipe
# python is installed from source, you may change to "package" to install from package
# comment these out if you have the correct java and python prereqs
# python will also run and require the build-essential cookbook to build
# setup the proper datastax repositories for the distro

include_recipe "java"

# setup the proper datastax repositories for the distro
case node['platform_family']
when "rhel","fedora"
 # use the yum cookbook
 include_recipe "yum::yum"
 # Add the DataStax repo, redhat centos fedora
 yum_repository "datastax" do
  repo_name "datastax"
  description "DataStax Repo for Apache Cassandra"
  url "http://rpm.datastax.com/community"
  action :add
 end
when "debian"
 # use the apt cookbook
 include_recipe "apt::default"
 # Add the DataStax repo, ubuntu debian
 apt_repository "datastax" do
  uri "http://debian.datastax.com/community"
  distribution "stable"
  components ["main"]
  key "http://debian.datastax.com/debian/repo_key"
  action :add
  notifies :run, resources(:execute => "apt-get update"), :immediately
 end
else
  Chef::Application.fatal!("Your distro is not yet supported/tested, patches welcome!")
end


# assemble the packages
datastax_packages = case node['platform_family']
when "rhel","fedora"
 include_recipe "yum::yum"
 %w{apache-cassandra1}
when "debian"
 %w{python-cql cassandra}
end


# loop to install packages
datastax_packages.each do |datastax_pack|
  package datastax_pack do
    action :install
  end
end

# Cassandra is installed, we proceed to set up the encryption

# find that java directory and setup the target encrypted java path
# the path here is hardcoded, if it does not match yours edit here
case node['platform_family']
when "rhel","fedora"
 java_dir="/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/jre"
 secjava_dir="/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/jresec"
 secjava="/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/jresec/bin/java"
 # sed argument to edit the cassandra startup
 startup_edit="12 i\ export JAVA_HOME=#{secjava_dir}"
 #acl_rule1="/etc/init.d/cassandra --exec=/bin/bash"
 acl_rule1="/bin/bash"
 acl_rule2="/usr/bin/numactl"
 #acl_rule2="#{secjava} --exec=/bin/bash --children=/bin/bash"
when "debian"
 java_dir="/usr/bin/jsvc"
 secjava_dir="/usr/bin/jsvcsec"
 secjava="/usr/bin/jsvcsec"
 # sed argument to edit the cassandra startup
 startup_edit="s/jsvc$/jsvcsec/g"
 acl_rule1="/etc/init.d/cassandra --exec=/bin/dash"
 acl_rule2="/usr/bin/lsof"
end

# before anything we stop cassandra
# make a copy of java
# encrypt it with @securejava container
# edit the cassandra startup
# create the ACLs
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
script "make a copy of java" do
 interpreter "bash"
 user "root"
 cwd "/tmp"
 code <<-EOH
 service cassandra stop
 cp -rp #{java_dir} #{secjava_dir}
 zncrypt-move encrypt @securejava #{secjava_dir} /mnt/zncrypt
 sed -i '#{startup_edit}' /etc/init.d/cassandra
 printf "#{passphrase}\n#{passphrase2}\n" | zncrypt acl --add --rule="ALLOW @securejava * #{acl_rule1}"
 printf "#{passphrase}\n#{passphrase2}\n" | zncrypt acl --add --rule="ALLOW @securejava * #{acl_rule2}"
 zncrypt-move encrypt @cassandra /var/lib/cassandra /mnt/zncrypt
 ezncrypt -e @cassandra /var/lib/cassandra
 printf "#{passphrase}\n#{passphrase2}\n" | zncrypt set --mode=admin
 printf "#{passphrase}\n#{passphrase2}\n" | zncrypt acl --add --rule="ALLOW @cassandra * #{zncrypt_mount}/securejava#{secjava}"
 printf "#{passphrase}\n#{passphrase2}\n" | zncrypt acl --add --rule="ALLOW @securejava * #{zncrypt_mount}/securejava#{secjava}"
 printf "#{passphrase}\n#{passphrase2}\n" | zncrypt set --mode=enforcing
 service cassandra start
 EOH
end
