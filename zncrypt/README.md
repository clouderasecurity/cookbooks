Description
===========

Installs zNcrypt 3 and all prerequistes.

Requirements
============

Platform
--------

* Ubuntu 12.04+
* CentOS, RedHat Enterprise Linux 6+

Tested on:

* Ubuntu 12.04
* CentOS 6.4

Cookbooks
---------

The `apt` and `yum` (version < 2.4.4) cookbooks are required to configure the system package manager as well as add the necessary GPG signing keys. The `openssl` cookbook is also recommended if you will be utilizing the auto-generated password functionality.

To install each cookbook:

 `knife cookbook site install apt`
 
 `knife cookbook site install yum 2.4.4`
 
 `knife cookbook site install openssl`

Then upload them to your chef server:

 `knife cookbook upload --all`

The `zncrypt::cassandra` recipe depends on Java, by default this is the OpenJDK version. This can be installed with:

 `knife cookbook site install java`

Attributes
==========

See `attributes/default.rb` for default values:

* `default["zncrypt"]["zncrypt_keyserver"]` - Hostname of keyserver to register client against.
* `default["zncrypt"]["zncrypt_org"]` - Organization to register zNcrypt client against (provided by Gazzang).
* `default["zncrypt"]["zncrypt_auth"]` - Authorization code tied to organization above (provided by Gazzang).
* `default["zncrypt"]["zncrypt_mount"]` - Location to mount encrypted file system. Note: No data will be stored at this location, only accessed.
* `default["zncrypt"]["zncrypt_storage"]` - Location to store encrypted data. Note: All data encrypted will be stored in this location (and accessed through the mount point).
* `default["zncrypt"]["passphrase"]` - Master password used to configure zNcrypt. This password will be used to alter any and all zNcrypt configuration. Alternatively, this can be commented out and a passphrase will be generated for you and stored in the databag tied to this instance.


Usage
=====

    include_recipe "zncrypt::default" - installs, configures, and activates zNcrypt
    include_recipe "zncrypt::install" - only installs zNcrypt, no configuration
    include_recipe "zncrypt::cassandra" - installs Cassandra and configures zNcrypt
    include_recipe "zncrypt::mongodb" -installs MongoDB and configures zNcrypt
    
All of the above commands will install zNcrypt 3 and its dependencies.

Data Bag
========

Add a databag for each server where zNcrypt is active:

  "data_bag": "masterkey_bag",
  "name": "masterkey_bag",
  "json_class": "Chef::DataBagItem",
  "chef_type": "data_bag_item",
  "raw_data": {
    "id": "key",
    "passphrase": "yourpassphrase",
  }


License and Author
==================

Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)

Copyright:: 2014 Gazzang, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
