# Class: vagrant::install
#
# This class installs vagrant
#
# == Variables
#
# Refer to vagrant class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by vagrant
#
class vagrant::install inherits vagrant {

  case $::vagrant::install {

    package: {
      package { 'vagrant':
        ensure => $vagrant::manage_package,
        name   => $vagrant::package,
      }
    }

    gem: {

      if ! defined(Package['rubygems']) {
        package { 'rubygems' : ensure => present }
      }

      package { 'vagrant':
        ensure   => $vagrant::manage_package,
        name     => $vagrant::package,
        provider => 'gem',
      }
    }

    default: { }
  }

}
