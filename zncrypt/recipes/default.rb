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
begin
 # check if there is a license pool already and skip creating
 data_bag('license_pool')
rescue
 #include the secure password from openssl recipe
 ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

 # create a data bag for licensing pool
 license_pool = Chef::DataBag.new
 license_pool.name('license_pool')
 license_pool.save
 # create json for data bag item for each node
 ubuntu = {	
   # use the node name as the id
   "id" => "ubuntu", 
   # set your product key provided by Gazzang
   # this license will auto reset every hour, if your first registrationi
   # fails try again in an hour or contact sales@gazzang.com
   "license" => "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
   # set your activation code provided by Gazzang
   "activation_code" => "123412341234",
   # random passphrase
   "passphrase" => secure_password,
   # random passphrase
   "passphrase2" => secure_password,
 }
 databag_item = Chef::DataBagItem.new
 databag_item.data_bag('license_pool')
 databag_item.raw_data = ubuntu 
 databag_item.save
 centos	 = {
   # use the node name as the id
   "id" => "centos",
   # set your product key provided by Gazzang
   # this license will auto reset every hour, if your first registrationi
   # fails try again in an hour or contact sales@gazzang.com
   "license" => "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
   # set your activation code provided by Gazzang
   "activation_code" => "123412341234",
   # random passphrase
   "passphrase" => secure_password,
   # random passphrase
   "passphrase2" => secure_password,
 }
 databag_item = Chef::DataBagItem.new
 databag_item.data_bag('license_pool')
 databag_item.raw_data = centos
 databag_item.save
end

# installs zncrypt
include_recipe "zncrypt::zncrypt"
# configures the directories using the configuraiton from the databag
include_recipe "zncrypt::configdirs"
# activates the license using the data bag 
include_recipe "zncrypt::activate"
