Description
===========

Installs zNcrypt and prerequistes

Requirements
============

Platform
--------

* Debian, Ubuntu
* CentOS, Red Hat, Fedora

Tested on:

* Ubuntu 10.04, 11.10
* CentOS 6.2

Cookbooks
---------

Requires apt and yum cookbooks to add gpg keys and gazzang repo.

 git clone git://github.com/opscode-cookbooks/apt
 knife cookbook upload apt


 git clone git://github.com/opscode-cookbooks/yum
 knife cookbook upload yum


Requires a C compiler for Dynamic Kernel Module compilation.


Attributes
==========


Usage
=====

    include_recipe "zncrypt::zncrypt"
    
This will install zNcrypt, dkms and the required kernel headers.

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