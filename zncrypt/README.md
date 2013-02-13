Description
===========

Installs zNcrypt 3.x and prerequistes

Requirements
============

Platform
--------

* Debian, Ubuntu
* CentOS, Red Hat, Fedora

Tested on:

* Ubuntu 10.04, 12.04
* CentOS 6.2

Cookbooks
---------

Requires apt and yum cookbooks to add gpg keys and gazzang repo.
Requires openssl cookbook to generate a strong passhrase

 `git clone git://github.com/opscode-cookbooks/apt
 knife cookbook upload apt`

 `git clone git://github.com/opscode-cookbooks/yum
 knife cookbook upload yum`

 `git clone git://github.com/opscode-cookbooks/openssl
 knife cookbook upload openssl`

The cassandra recipe depends on Java, by default is OpenJDK

 `git clone git://github.com/opscode-cookbooks/java
 knife cookbook upload java`

Requires a C compiler for Dynamic Kernel Module compilation.


Attributes
==========

See `attributes/default.rb` for default values

* `node["zncrypt"]["zncrypt_mount"]` - mount point for zncrypt, default `/var/lib/ezncrypt/ezncrypted`.
* `node["zncrypt"]["zncrypt_storage"]` - directory to store encrypted data, default `/var/lib/ezncrypt/storage`.
* `node["zncrypt"]["zncrypt_admin_email"]` - email address of zNcrypt license key Administrator`.

Usage
=====

    include_recipe "zncrypt::default" - installs, configures and activates zncrypt
    include_recipe "zncrypt::zncrypt" - installs only zncrypt
    include_recipe "zncrypt::cassandra" -installs cassandra and configures zncrypt
    include_recipe "zncrypt::mongodb" -installs mongodb and configures zncrypt
    
This will install zNcrypt 3.x, dkms and the required kernel headers.

Data Bag
========

Add a databag for each server with a Gazzang license and activation code

  "data_bag": "masterkey_bag",
  "name": "masterkey_bag",
  "json_class": "Chef::DataBagItem",
  "chef_type": "data_bag_item",
  "raw_data": {
    "id": "key1",
    "passphrase": "yourpassphrase",
    "passphrase2": "yourpassphrase",
  }


License and Author
==================

Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)

Copyright:: 2012 Gazzang, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
