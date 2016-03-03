# class openssh::server
#
# = concat order
# 00 - baseconf
# (...)
# 80 - AllowUser
# 81 - AllowUser list
# 82 - AllowUser intro
# (...)
# 90 - DenyUser
# 91 - DenyUser list
# 92 - DenyUser intro
#
class openssh::server (
                        $permitrootlogin=true,
                        $usedns=false,
                        $usepam=true,
                        $x11forwarding=true,
                        $passwordauth=true,
                        $permitemptypasswords=false,
                        $enableldapsshkeys=false,
                        $syslogfacility=$openssh::params::syslogfacility_default,
                        $banner=undef,
                        $allowusers=undef,
                        $denyusers=undef,
                        $ensure ='running',
                        $manage_service=true,
                        $manage_docker_service=true,
                        $enable =true,
                      )inherits params {

  validate_array($allowusers)
  validate_array($denyusers)

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  package { $openssh::params::package_sshd:
    ensure => 'installed',
  }

  if ($openssh::params::package_sftp!=undef)
  {
    package { $openssh::params::package_sftp:
      ensure => 'installed',
    }
  }

  if($enableldapsshkeys)
  {
    exec { 'check presence /usr/libexec/openssh/ssh-ldap-wrapper':
      command => '/bin/false',
      unless  => '/usr/bin/test -e /usr/libexec/openssh/ssh-ldap-wrapper',
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
    notify  => Class['openssh::service'],
  }

  concat::fragment { "${openssh::params::sshd_config} base conf":
    target  => $openssh::params::sshd_config,
    order   => '00',
    content => template("${module_name}/${openssh::params::sshd_config_template}"),
  }

  class { 'openssh::service':
    ensure                => $ensure,
    manage_service        => $manage_service,
    manage_docker_service => $manage_docker_service,
    enable                => $enable,
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
