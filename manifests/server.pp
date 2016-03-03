# class openssh::server
#
# concats
# 00 - baseconf
# (...)
# 90 - AllowUser
# 91 - AllowUser list
# 92 - AllowUser intro
# (...)
# 90 - DenyUser
# 91 - DenyUser list
# 92 - DenyUser intro
#
class openssh::server (
                        $permitrootlogin='yes',
                        $usedns='no',
                        $enableldapsshkeys=false,
                        $banner=undef,
                        $allowusers=undef,
                        $denyusers=undef,
                      )inherits params {

  validate_array($allowusers)
  validate_array($denyusers)

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  package { $openssh::params::package_sshd:
    ensure => 'installed',
  }

  if ! defined(Package[$openssh::params::package_sftp])
  {
    package { $openssh::params::package_sftp:
      ensure => 'installed',
    }
  }

  if($enableldapsshkeys)
  {
    exec { "check presence /usr/libexec/openssh/ssh-ldap-wrapper":
      command => '/bin/true',
      onlyif  => '/usr/bin/test -e /usr/libexec/openssh/ssh-ldap-wrapper',
      before  => File[$openssh::params::sshd_config],
    }
  }

  exec { 'keygen rsa key':
    command => 'ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key',
    creates => '/etc/ssh/ssh_host_rsa_key'
  }

  concat { $openssh::params::sshd_config:
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => [
                  Exec['keygen rsa key'],
                  Package[ [ $openssh::params::package_sshd, $openssh::params::package_sftp ] ],
              ],
    notify  => Service[$sshd_service],
  }

  concat::fragment { "${openssh::params::sshd_config} base conf":
    target  => $openssh::params::sshd_config,
    order   => '00',
    content => template("${module_name}/${openssh::params::sshd_config_template}"),
  }

  service { $sshd_service:
    ensure => 'running',
    enable => true,
  }

  if($denyusers!=undef)
  {
    openssh::denyuser { $denyusers:
    }
  }

  if($allowusers!=undef)
  {
    openssh::allowuser { $allowusers:
    }
  }

}
