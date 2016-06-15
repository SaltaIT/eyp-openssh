define openssh::denyuser($username = $name) {

  if ! defined(Class['openssh::server'])
  {
    fail('You must include the openssh::server base class before using any openssh::server defined resources')
  }

  if(!defined(Concat::Fragment["${openssh::params::sshd_config} denyuser base"]))
  {
    concat::fragment { "${openssh::params::sshd_config} denyuser base":
      target  => $openssh::params::sshd_config,
      order   => '90',
      content => 'DenyUsers ',
    }

    concat::fragment { "${openssh::params::sshd_config} denyuser intro":
      target  => $openssh::params::sshd_config,
      order   => '92',
      content => "\n",
    }
  }

  concat::fragment { "${openssh::params::sshd_config} denyuser ${username}":
    target  => $openssh::params::sshd_config,
    order   => '91',
    content => "${username} ",
  }

}
