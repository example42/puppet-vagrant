# Class: vagrant::params
#
# This class defines default parameters used by the main module class vagrant
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to vagrant class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class vagrant::params {

  ### Module specific parameters
  $install = 'gem'  

  ### Application related parameters

  $package = $::operatingsystem ? {
    default => 'vagrant',
  }

  $config_dir = $::operatingsystem ? {
    default => '',
  }

  $config_file = $::operatingsystem ? {
    default => '',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $data_dir = $::operatingsystem ? {
    default => '/opt/vagrant',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/vagrant',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/vagrant/vagrant.log',
  }

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = '127.0.0.1'
  $puppi = false
  $puppi_helper = 'command'
  $debug = false
  $audit_only = false

}
