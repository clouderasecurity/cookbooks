#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Attribute:: default
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

# Keyserver hostname and credentials.
# These are used during the initial registration with the keyserver, prior to 
# encrypting any data. Registration credentials are provided by Gazzang
# support. If you are unsure of your registration credentials, please send a
# note to support@gazzang.com.
default['zncrypt']['zncrypt_keyserver'] = 'ztdemo.gazzang.net'
default['zncrypt']['zncrypt_org'] = 'yourorganization'
default['zncrypt']['zncrypt_auth'] = 'yourauthcode'

# Set the storage location and mount point for all encrypted data.
default['zncrypt']['zncrypt_mount'] = '/var/lib/zncrypt/encrypted'
default['zncrypt']['zncrypt_storage'] = '/var/lib/zncrypt/.private'

# Master password used to set and update zNcrypt configuration parameters.
# If commented out, an auto-generated password will be created for you and 
# placed inside of a Chef databag.
# WARNING!
# Please keep this password safe when moving into a production environment, 
# as this is all that is needed to decrypt/expose data.
default['zncrypt']['passphrase'] = 'changethisthingplease'

