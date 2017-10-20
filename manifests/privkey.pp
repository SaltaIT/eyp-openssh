# puppet2sitepp @sshprivkeys
define openssh::privkey(
                            $user       = $name,
                            $group      = $name,
                            $homedir    = "/home/${name}",
                            $type       = 'rsa',
                            $ensure     = 'present',
                            $passphrase = '',
                            $key_source = undef,
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

  if($key_source==undef)
  {
    exec { "sshkeygen ${user} ${homedir} ${type}":
      command => "yes | ssh-keygen -N '${passphrase}' -f ${homedir}/.ssh/id_${type}",
      unless  => "grep BEGIN ${homedir}/.ssh/id_${type}",
      require => File["${homedir}/.ssh"],
    }

    file { "${homedir}/.ssh/id_${type}":
      ensure  => $ensure,
      owner   => $user,
      group   => $group,
      mode    => '0600',
      require => Exec["sshkeygen ${user} ${homedir} ${type}"],
    }

    file { "${homedir}/.ssh/id_${type}.pub":
      ensure  => $ensure,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      require => Exec["sshkeygen ${user} ${homedir} ${type}"],
    }
  }
  else
  {
    file { "${homedir}/.ssh/id_${type}":
      ensure => $ensure,
      owner  => $user,
      group  => $group,
      mode   => '0600',
      source => $key_source,
    }

    exec { "get public key ${user} ${homedir} ${type}":
      command => "ssh-keygen -y -f ${homedir}/.ssh/id_${type} > ${homedir}/.ssh/id_${type}.pub",
      unless  => "bash -c '(ssh-keygen -y -f ${homedir}/.ssh/id_${type} | md5sum | awk '{ print \$1 }'; cat ${homedir}/.ssh/id_${type}.pub | md5sum | awk '{ print \$1 }') | uniq | wc -l | grep 1'";
    }

    file { "${homedir}/.ssh/id_${type}.pub":
      ensure  => $ensure,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      require => Exec["get public key ${user} ${homedir} ${type}"],
    }
  }
}
