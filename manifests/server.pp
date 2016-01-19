class openssh::server (
                        $permitrootlogin='yes',
                        $usedns='no',
                        $enableldapsshkeys=false,
                        $banner=undef,
                      )inherits params {
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
      onlyif => '/usr/bin/test -e /usr/libexec/openssh/ssh-ldap-wrapper',
      before => File[$openssh::params::sshd_config],
    }
  }

  exec { 'keygen rsa key':
    command => 'ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key',
    creates => '/etc/ssh/ssh_host_rsa_key'
  }

  file { $openssh::params::sshd_config:
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => '0600',
    require => [
                 Exec['keygen rsa key'],
                 Package[ [ $openssh::params::package_sshd, $openssh::params::package_sftp ] ],
               ],
    content => template("openssh/${openssh::params::sshd_config_template}"),
    notify => Service[$sshd_service],
  }

  service { $sshd_service:
    ensure => 'running',
    enable => true,
  }

}
