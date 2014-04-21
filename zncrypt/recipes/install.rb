#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Recipe:: install
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

# setup the proper repositories for the distro
case node['platform_family']
when "rhel","fedora"
    # use the yum cookbook
    include_recipe "yum::default"
    # Add the Gazzang gpg key and repo, redhat centos fedora
    yum_key "RPM-GPG-KEY-gazzang" do
        url "https://archive.gazzang.com/gpg_gazzang.asc"
        action :add
    end
    yum_repository "gazzang" do
        repo_name "gazzang"
        description "RHEL $releasever - gazzang.com - base"
        url "https://archive.gazzang.com/redhat/stable/$releasever"
        key "RPM-GPG-KEY-gazzang"
        action :add
    end
when "debian"
    # use the apt cookbook
    include_recipe "apt::default"
    # Add the Gazzang gpg key and repoi, ubuntu debian
    apt_repository "gazzang" do
        uri "https://archive.gazzang.com/#{node['platform']}/stable"
        distribution node['lsb']['codename']
        components ["main"]
        key "https://archive.gazzang.com/gpg_gazzang.asc"
        action :add
        notifies :run, resources(:execute => "apt-get update"), :immediately
    end
else
    Chef::Application.fatal!("Your distro is not yet supported/tested, patches welcome!")
end

# assemble the packages
zncrypt_packages = case node['platform_family']
when "rhel","fedora"
    include_recipe "yum::default"
    %w{kernel-devel kernel-headers dkms haveged zncrypt}
when "debian"
    include_recipe "apt::default"
    uname = %x(uname -r)
    %W{linux-headers-#{uname} dkms make perl haveged zncrypt}
end

# loop to install packages
zncrypt_packages.each do |p|
    package p do
        action :install
    end
end

# start haveged to decrease registration time
script "Starting haveged for secure entropy generation." do
    interpreter "bash"
    user "root"
    code <<-EOH
    /etc/init.d/haveged start
    EOH
end