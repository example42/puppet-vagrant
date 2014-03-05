# = Class: vagrant
#
# This is the main vagrant class
#
#
# == Parameters
#
# Module specifi parameter
#
# [*install*]
#   Kind of installation to attempt:
#     - package : Installs vagrant using the OS common packages
#     - gem  : Installs vagrant as a gem
#   Can be defined also by the variable $vagrant_install
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, vagrant class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $vagrant_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, vagrant main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $vagrant_source
#
# [*source_dir*]
#   If defined, the whole vagrant configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $vagrant_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $vagrant_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, vagrant main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $vagrant_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $vagrant_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $vagrant_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $vagrant_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $vagrant_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $vagrant_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for vagrant checks
#   Can be defined also by the (top scope) variables $vagrant_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $vagrant_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $vagrant_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $vagrant_puppi_helper
#   and $puppi_helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#   Can be defined also by the (top scope) variables $vagrant_firewall
#   and $firewall
#
# [*firewall_tool*]
#   Define which firewall tool(s) (ad defined in Example42 firewall module)
#   you want to use to open firewall for vagrant port(s)
#   Can be defined also by the (top scope) variables $vagrant_firewall_tool
#   and $firewall_tool
#
# [*firewall_src*]
#   Define which source ip/net allow for firewalling vagrant. Default: 0.0.0.0/0
#   Can be defined also by the (top scope) variables $vagrant_firewall_src
#   and $firewall_src
#
# [*firewall_dst*]
#   Define which destination ip to use for firewalling. Default: $ipaddress
#   Can be defined also by the (top scope) variables $vagrant_firewall_dst
#   and $firewall_dst
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $vagrant_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $vagrant_audit_only
#   and $audit_only
#
# Default class params - As defined in vagrant::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of vagrant package
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include vagrant"
# - Call vagrant as a parametrized class
#
# See README for details.
#
#
# == Author
#   Alessandro Franceschi <al@lab42.it/>
#
class vagrant (
  $my_class            = params_lookup( 'my_class' ),
  $install             = params_lookup( 'install' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $disable             = params_lookup( 'disable' ),
  $disableboot         = params_lookup( 'disableboot' ),
  $monitor             = params_lookup( 'monitor' , 'global' ),
  $monitor_tool        = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target      = params_lookup( 'monitor_target' , 'global' ),
  $puppi               = params_lookup( 'puppi' , 'global' ),
  $puppi_helper        = params_lookup( 'puppi_helper' , 'global' ),
  $firewall            = params_lookup( 'firewall' , 'global' ),
  $firewall_tool       = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src        = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst        = params_lookup( 'firewall_dst' , 'global' ),
  $debug               = params_lookup( 'debug' , 'global' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $package             = params_lookup( 'package' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $data_dir            = params_lookup( 'data_dir' ),
  $log_dir             = params_lookup( 'log_dir' ),
  $log_file            = params_lookup( 'log_file' )
  ) inherits vagrant::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_package = $vagrant::bool_absent ? {
    true  => 'absent',
    false => $vagrant::version,
  }

  $manage_file = $vagrant::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $vagrant::bool_absent == true
  or $vagrant::bool_disable == true
  or $vagrant::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $vagrant::bool_absent == true
  or $vagrant::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $vagrant::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $vagrant::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $vagrant::source ? {
    ''        => undef,
    default   => $vagrant::source,
  }

  $manage_file_content = $vagrant::template ? {
    ''        => undef,
    default   => template($vagrant::template),
  }

  ### Managed resources
  include vagrant::install

  if $vagrant::data_dir {
    file { 'vagrant.data_dir':
      ensure  => directory,
      path    => $vagrant::data_dir,
      mode    => '0755',
      owner   => $vagrant::config_file_owner,
      group   => $vagrant::config_file_group,
      audit   => $vagrant::manage_audit,
    }
  }

  if $vagrant::config_file {
    file { 'vagrant.conf':
      ensure  => $vagrant::manage_file,
      path    => $vagrant::config_file,
      mode    => $vagrant::config_file_mode,
      owner   => $vagrant::config_file_owner,
      group   => $vagrant::config_file_group,
      source  => $vagrant::manage_file_source,
      content => $vagrant::manage_file_content,
      replace => $vagrant::manage_file_replace,
      audit   => $vagrant::manage_audit,
    }
  }

  # The whole vagrant configuration directory can be recursively overriden
  if $vagrant::source_dir
  and $vagrant::config_dir {
    file { 'vagrant.dir':
      ensure  => directory,
      path    => $vagrant::config_dir,
      source  => $vagrant::source_dir,
      recurse => true,
      purge   => $vagrant::bool_source_dir_purge,
      replace => $vagrant::manage_file_replace,
      audit   => $vagrant::manage_audit,
    }
  }


  ### Include custom class if $my_class is set
  if $vagrant::my_class {
    include $vagrant::my_class
  }


  ### Provide puppi data, if enabled ( puppi => true )
  if $vagrant::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'vagrant':
      ensure    => $vagrant::manage_file,
      variables => $classvars,
      helper    => $vagrant::puppi_helper,
    }
  }

  ### Debugging, if enabled ( debug => true )
  if $vagrant::bool_debug == true {
    file { 'debug_vagrant':
      ensure  => $vagrant::manage_file,
      path    => "${settings::vardir}/debug-vagrant",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
    }
  }

}
