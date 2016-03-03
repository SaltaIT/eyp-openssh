define openssh::allowuser($username=$name) {

  if ! defined(Class['openssh::server'])
  {
    fail('You must include the openssh::server base class before using any openssh::server defined resources')
  }

  if(!defined(Concat::Fragment["${openssh::params::sshd_config} allowuser base"]))
  {
    concat::fragment { "${openssh::params::sshd_config} allowuser base":
      target  => $openssh::params::sshd_config,
      order   => '80',
      content => 'AllowUsers ',
    }

    concat::fragment { "${openssh::params::sshd_config} allowuser intro":
      target  => $openssh::params::sshd_config,
      order   => '82',
      content => "\n",
    }
  }

  concat::fragment { "${openssh::params::sshd_config} allowuser ${username}":
    target  => $openssh::params::sshd_config,
    order   => '81',
    content => "${username} ",
  }

}
