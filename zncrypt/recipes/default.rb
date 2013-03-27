#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Recipe:: default
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
# All rights reserved - Do Not Redistribute
#

# NOTE this default.rb recipe is meant to be used as a starting point
# and is useful for testing with a single node
# the example logic below would need to be added to your own recipe

# check if the data bag exists, use a begin / rescue to handle the exception
passphrase = node['zncrypt']['passphrase']
passphrase2 = node['zncrypt']['passphrase2']
if passphrase.nil?
begin
 # check if there is a masterkey_bag already and skip creating
 data_bag('masterkey_bag')
rescue
 #include the secure password from openssl recipe
 ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

 # create a data bag for licensing pool
 masterkey_bag = Chef::DataBag.new
 masterkey_bag.name('masterkey_bag')
 masterkey_bag.save
 # create json for data bag item for each node
 key1 = {	
   "id" => "key1", 
   # random passphrase
   "passphrase" => secure_password,
   # random passphrase
   "passphrase2" => secure_password,
 }
 databag_item = Chef::DataBagItem.new
 databag_item.data_bag('masterkey_bag')
 databag_item.raw_data = key1 
 databag_item.save
end
end

# installs zncrypt
include_recipe "zncrypt::zncrypt"
# activates the zncrypt and stores the master key using the data bag 
include_recipe "zncrypt::activate"
# configures the directories using the configuration from the databag
include_recipe "zncrypt::configdirs"
