#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Recipe:: activate
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

# activate zncrypt, for that we need a license, activation code provided by Gazzang
begin
 # check if there is a license pool otherwise skip activation
 data_bag('license_pool')
 license=data_bag_item('license_pool', "#{node.name}")['license']
 activation_code=data_bag_item('license_pool', "#{node.name}")['activation_code']
 # we also need a passhprase and second passphrase, we will generate a random one
 passphrase=data_bag_item('license_pool', "#{node.name}")['passphrase']
 passphrase2=data_bag_item('license_pool', "#{node.name}")['passphrase2']
 # build the arguments to the activate command
 activate_args="--activate --license=#{license} --activation-code=#{activation_code} --passphrase=#{passphrase} --passphrase2=#{passphrase2}"
 script "activate zNcrypt" do
  interpreter "bash"
  user "root"
  code <<-EOH
  mkdir /var/log/ezncrypt
  ezncrypt-activate #{activate_args}
  EOH
 end
rescue
 #  Skip the activation
end
