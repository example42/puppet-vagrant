# Puppet module: vagrant

## DEPRECATION NOTICE
This module is no more actively maintained and will hardly be updated.

Please find an alternative module from other authors or consider [Tiny Puppet](https://github.com/example42/puppet-tp) as replacement.

If you want to maintain this module, contact [Alessandro Franceschi](https://github.com/alvagante)


This is a Puppet module for vagrant based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-vagrant

Released under the terms of Apache 2 License.

This module requires functions provided by the Example42 Puppi module (you need it even if you don't use and install Puppi)

For detailed info about the logic and usage patterns of Example42 modules check the DOCS directory on Example42 main modules set.

## USAGE - Module specific 

* Create a Vagrant Multi VM environment. The user has to specified (Note: User must exist)

        vagrant::environment { 'test42':
          user => 'al'
        }
        vagrant::vm { 'test_lenny64':
          environment => 'test42',
          box         => 'debian_lenny_64',
          box_url     => 'http://puppetlabs.s3.amazonaws.com/pub/debian_lenny_64.box',
        }
        vagrant::vm { "test_lucid64":
            environment => "test42" ,
            box => "lucid64" ,
            box_url => "http://files.vagrantup.com/lucid64.box"
        }
        
        
## USAGE - Basic management

* Install vagrant with default settings

        class { 'vagrant': }

* Install a specific version of vagrant package

        class { 'vagrant':
          version => '1.0.1',
		}

* Remove vagrant package

class { 'vagrant':
          absent => true
        }

* Enable auditing without without making changes on existing vagrant configuration files

        class { 'vagrant':
          audit_only => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for a specific config file (by default no config file is managed, it is if you set the config_file param)

        class { 'vagrant':
          config_file => '/etc/vagrant.conf' ,
          source      => [ "puppet:///modules/lab42/vagrant/vagrant.conf-${hostname}" , "puppet:///modules/lab42/vagrant/vagrant.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'vagrant':
          source_dir       => 'puppet:///modules/lab42/vagrant/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file (by default no config file is managed, it is if you set the config_file param). Note that template and source arguments are alternative. 

        class { 'vagrant':
          config_file => '/etc/vagrant.conf' ,
          template    => 'example42/vagrant/vagrant.conf.erb',
        }

* Automatically include a custom subclass

        class { 'vagrant':
          my_class => 'vagrant::example42',
        }


## USAGE - Example42 extensions management 
* Activate puppi (recommended, but disabled by default)

        class { 'vagrant':
          puppi    => true,
        }

* Activate puppi and use a custom puppi_helper template (to be provided separately with a puppi::helper define ) to customize the output of puppi commands 

        class { 'vagrant':
          puppi        => true,
          puppi_helper => 'myhelper', 
        }

* Activate automatic monitoring (recommended, but disabled by default). This option requires the usage of Example42 monitor and relevant monitor tools modules. Monitoring is managed for each singleVirtuax box managed with vagrant::vm.

        class { 'vagrant':
          monitor      => true,
          monitor_tool => [ 'nagios' , 'monit' , 'munin' ],
        }

* Activate automatic firewalling. This option requires the usage of Example42 firewall and relevant firewall tools modules. Firewalling is managed for each singleVirtuax box managed with vagrant::vm. 

        class { 'vagrant':       
          firewall      => true,
          firewall_tool => 'iptables',
          firewall_src  => '10.42.0.0/24',
          firewall_dst  => $ipaddress_eth0,
        }


[![Build Status](https://travis-ci.org/example42/puppet-vagrant.png?branch=master)](https://travis-ci.org/example42/puppet-vagrant)
