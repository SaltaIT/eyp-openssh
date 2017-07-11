# puppet2sitepp @sshprivkeys
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
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }

  exec { "sshkeygen ${user} ${homedir} ${type}":
    command => "yes | ssh-keygen -N '${passphrase}' -f ${homedir}/.ssh/id_${type}",
    unless  => "grep BEGIN ${homedir}/.ssh/id_${type}",
    require => File["${homedir}/.ssh"],
  }

  file { "${homedir}/.ssh/id_${type}":
    ensure  => 'present',
    owner   => $user,
    group   => $group,
    mode    => '0600',
    require => Exec["sshkeygen ${user} ${homedir} ${type}"],
  }

  file { "${homedir}/.ssh/id_${type}.pub":
    ensure  => 'present',
    owner   => $user,
    group   => $group,
    mode    => '0644',
    require => Exec["sshkeygen ${user} ${homedir} ${type}"],
  }

}
