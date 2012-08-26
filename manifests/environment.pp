define vagrant::environment  (
  $user,
  $puppet_manifest_file = 'vagrant/puppet/site.pp',
  $puppet_server        = $puppet_server ) {

  require vagrant

  file { "${vagrant::data_dir}/${name}":
    ensure  => directory,
    owner   => $user,
    require => File[ $vagrant::data_dir ],
  }

  file { "${vagrant::data_dir}/${name}/manifests":
    ensure  => directory,
    owner   => $user,
    require => File[ "${vagrant::data_dir}/${name}"],
  }

  file { "${vagrant::data_dir}/${name}/manifests/site.pp":
    ensure  => present,
    owner   => $user,
    content => template( $puppet_manifest_file ),
    require => File[ "${vagrant::data_dir}/${name}/manifests" ],
  }

  file { "${vagrant::data_dir}/${name}/manifests/puppet.conf.erb":
    ensure  => present,
    owner   => $user,
    content => template('vagrant/puppet/puppet.conf.erb'),
    require => File[ "${vagrant::data_dir}/${name}/manifests" ],
  }


  concat { "${vagrant::data_dir}/${name}/Vagrantfile":
    mode    => '0644',
    owner   => $user,
    require => File[ "${vagrant::data_dir}/${name}"],
  }

  concat::fragment{ "Vagrantfile_HEADER_${name}":
    target  => "${vagrant::data_dir}/${name}/Vagrantfile",
    content => template('vagrant/concat/Vagrantfile_HEADER.erb'),
    order   => '1',
  }

  concat::fragment{ "Vagrantfile_FOOTER_${name}":
    target  => "${vagrant::data_dir}/${name}/Vagrantfile",
    content => template('vagrant/concat/Vagrantfile_FOOTER.erb'),
    order   => '99',
  }

}
