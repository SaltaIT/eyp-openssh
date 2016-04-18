#
class openssh::client($gssapi_authentication=true) inherits openssh::params {

  package { $openssh::params::package_ssh_client:
      ensure => 'installed',
  }

  concat { $openssh::params::ssh_config:
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$openssh::params::package_ssh_client],
  }

  #TODO: afegir ssh_config
  concat::fragment { "${openssh::params::ssh_config} base conf":
    target  => $openssh::params::ssh_config,
    order   => '00',
    content => template("${module_name}/ssh_config.erb"),
  }

}
