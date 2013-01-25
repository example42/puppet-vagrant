# Define: vagrant::vm
#
# Inserts a vm in a vagrant environment
#
# Parameters:
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

  concat::fragment{ "Vagrantfile_vm_${environment}_$name":
    ensure  => $ensure,
    target  => "${vagrant::data_dir}/${environment}/Vagrantfile",
    content => template('vagrant/concat/Vagrantfile_vm.erb'),
    order   => $order,
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
