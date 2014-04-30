#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Recipe:: register
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

passphrase = node['zncrypt']['passphrase']
if passphrase.nil? 
    data_bag('masterkey_bag')
    passphrase = data_bag_item('masterkey_bag', 'encryption_key')['passphrase']
end

unless passphrase.nil?
    org = node['zncrypt']['zncrypt_org']
    auth = node['zncrypt']['zncrypt_auth']
    server = node['zncrypt']['zncrypt_keyserver']
    # build the arguments to the activate command
    activate_args="-s #{server} -o #{org} --auth=#{auth} --key-type=single-passphrase"
    if node['zncrypt']['skip_ssl']
        activate_args = activate_args + " --skip-ssl-check"
    end
    script "Register zNcrypt with zTrustee Key Management Server" do
        interpreter "bash"
        user "root"
        code <<-EOH
        printf "#{passphrase}\n#{passphrase}" | zncrypt register #{activate_args}
        EOH
        not_if do
          File.exists?("/etc/zncrypt/ztrustee/clientname")
        end
    end
end
