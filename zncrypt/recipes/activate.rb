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

# activate zncrypt, for that we need a master key and license administrator's email
passphrase = node['zncrypt']['passphrase']
passphrase2 = node['zncrypt']['passphrase2']
if passphrase.nil? 
 # check if there is a masterkey_bag otherwise skip activation
 data_bag('masterkey_bag')
 # we also need a passhprase and second passphrase, we will generate a random one
 passphrase=data_bag_item('masterkey_bag', 'key1')['passphrase']
 passphrase2=data_bag_item('masterkey_bag', 'key1')['passphrase2']
end
unless passphrase.nil?
 # grab license key administrator's email from attributes
 admin_email = node['zncrypt']['zncrypt_admin_email']
 # build the arguments to the activate command
 activate_args="--key-type=dual-passphrase"
 script "activate zNcrypt" do
  interpreter "bash"
  user "root"
  code <<-EOH
  # use printf to avoid logging of the passphrase
  printf "#{passphrase}\n#{passphrase}\n#{passphrase2}\n#{passphrase2}" | zncrypt register #{activate_args}
  printf "#{passphrase}\n#{passphrase2}\n" | zncrypt request-activation --contact=#{admin_email}
  EOH
 end
end
