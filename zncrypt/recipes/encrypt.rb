#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Recipe:: encrypt
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
mount = node['zncrypt']['zncrypt_mount']
acl = node['zncrypt']['acl_name']
targets = node['zncrypt']['to_encrypt']

passphrase = node['zncrypt']['passphrase']
if passphrase.nil?
    data_bag('masterkey_bag')
    passphrase=data_bag_item('masterkey_bag', 'encryption_key')['passphrase']
end

unless passphrase.nil?
    targets.each do |t|
        script "Encrypt target: #{t}" do
            interpreter "bash"
            user "root"
            code <<-EOH
            printf "#{passphrase}\n" | zncrypt-move encrypt @#{acl} #{t} #{mount}
            EOH
            not_if "test -L #{t}"
        end
    end
end
