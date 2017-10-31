#
class openssh::client (
                        $gssapi_authentication = true,
                        $send_env              = [
                         'LANG', 'LC_CTYPE', 'LC_NUMERIC', 'LC_TIME', 'LC_COLLATE',
                         'LC_MONETARY', 'LC_MESSAGES', 'LC_PAPER', 'LC_NAME',
                         'LC_ADDRESS', 'LC_TELEPHONE', 'LC_MEASUREMENTLC_IDENTIFICATION',
                         'LC_ALL', 'LANGUAGE', 'XMODIFIERS',
                        ],
                        $forward_x11_trusted   = true,
                      ) inherits openssh::params {

  if($openssh::params::package_ssh_client!=undef)
  {
    $sshclient_package=$openssh::params::package_ssh_client
    package { $openssh::params::package_ssh_client:
        ensure => 'installed',
    }
    $require_ssh_config=Package[$openssh::params::package_ssh_client]
  }
  else
  {
    $require_ssh_config=Class['openssh::server']
  }

  concat { $openssh::params::ssh_config:
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => $require_ssh_config,
  }

  #TODO: afegir ssh_config
  concat::fragment { "${openssh::params::ssh_config} base conf":
    target  => $openssh::params::ssh_config,
    order   => '00',
    content => template("${module_name}/ssh_config/ssh_config.erb"),
  }

}
