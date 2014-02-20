maintainer       "Gazzang, Inc."
maintainer_email "eddie.garcia@gazzang.com"
license          "Apache 2.0"
description      "Install and configure Gazzang's zNcrypt 3 Encryption Utilty."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.3"
%w{ apt yum openssl java }.each do |cb|
  depends cb
end
%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

recipe "zncrypt::install", "Install zNcrypt only. No configuration."
recipe "zncrypt::default", "Install and configure zNcrypt."
recipe "zncrypt::cassandra", "Install and configure zNcrypt with DataStax Cassandra."
recipe "zncrypt::mongodb", "Install and configure zNcrypt with MongoDB."

