# Define: vagrant::vm
#
# Inserts a vm in a vagrant environment 
#
# Parameters:
#
# TODO: 
# - Solve limit of single forward port and share per vm
# - Add vm configs settings
#
# Usage:
# You have to define at least one vagrant::environment and there place a
# Vagrantfile populated with one or multiple VMs
# vagrant::environment { "test42": user => "al" }
# vagrant::vm { "test-lucid64": environment => "test42" , box => "lucid64" , box_url => "http://files.vagrantup.com/lucid64.box" }
#
#
define vagrant::vm (
  $environment,
  $box                  = 'base',
  $box_url              = '',
  $network              = '',
  $ip_address           = '',
  $forward_hostport     = '',
  $forward_guestport    = '',
  $share_name           = '',
  $share_hostdir        = '',
  $share_guestmount     = '',
  $boot_mode            = '',
  $provision            = '',
  $puppet_server        = 'puppet',
  $puppet_node          = $::fqdn,
  $puppet_manifest_path = 'manifests',
  $puppet_manifest_file = 'site.pp',
  $puppet_module_path   = '',
  $puppet_options       = '',
  $chef_server          = '',
  $chef_cookbooks_path  = '',
  $shell_path           = '',
  $order                = '50',
  $ensure               = 'present' ) {

  include vagrant
  include concat::setup

  concat::fragment{ "Vagrantfile_vm_$environment_$name":
    target  => "${vagrant::basedir}/${environment}/Vagrantfile",
    content => template("vagrant/concat/Vagrantfile_vm.erb"),
    order   => $order,
    ensure  => $ensure,
  }

  ### Service monitoring, if enabled ( monitor => true )
  if $vagrant::bool_monitor == true {
    monitor::port { "vagrant_${vagrant::protocol}_${forward_hostport}":
      protocol => $vagrant::protocol,
      port     => $forward_hostport,
      target   => $vagrant::monitor_target,
      tool     => $vagrant::monitor_tool,
      enable   => $vagrant::manage_monitor,
    }
  }

  ### Firewall management, if enabled ( firewall => true )
  if $vagrant::bool_firewall == true {
    firewall { "vagrant_${vagrant::protocol}_${forward_hostport}":
      source      => $vagrant::firewall_src,
      destination => $vagrant::firewall_dst,
      protocol    => $vagrant::protocol,
      port        => $forward_hostport,
      action      => 'allow',
      direction   => 'input',
      tool        => $vagrant::firewall_tool,
      enable      => $vagrant::manage_firewall,
    }
  }

}
