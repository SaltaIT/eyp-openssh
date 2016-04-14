define openssh::privkey(
                            $user       = $name,
                            $group      = $name,
                            $homedir    = "/home/${name}",
                            $type       = 'rsa',
                            $ensure     = 'present',
                            $passphrase = '',
                          ) {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  file { "${homedir}/.ssh":
    ensure => 'directory'
    owner => $user,
    group => $group,
    mode => '0700',
  }

  exec { "sshkeygen ${user} ${homedir} ${type}":
    command => "ssh-keygen -N '${passphrase}' -f ${homedir}/.ssh/id_${type}",
    unless  => "grep ^ssh ${homedir}/.ssh/id_${type}",
    require => File["${homedir}/.ssh"],
  }

  file { "${homedir}/.ssh/id_${type}":
    ensure  => 'present',
    owner   => $user,
    group   => $group,
    mode    => '0600',
    require => Exec["sshkeygen ${user} ${homedir} ${type}"],
  }

}
