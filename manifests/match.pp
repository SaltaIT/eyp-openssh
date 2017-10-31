# puppet2sitepp @sshmatch
define openssh::match (
                        $groups                  = undef,
                        $users                   = undef,
                        $addresses               = undef,
                        $hosts                   = undef,
                        $chrootdirectory         = undef,
                        $forcecommand            = undef,
                        $allow_tcp_forwarding    = undef,
                        $allowed_ips             = undef,
                        $password_authentication = undef,
                        $description             = undef,
                      ) {
  #
  if($groups!=undef)
  {
    validate_array($groups)
  }

  if($users!=undef)
  {
    validate_array($users)
  }

  if($addresses!=undef)
  {
    validate_array($addresses)
  }

  if($hosts!=undef)
  {
    validate_array($hosts)
  }

  if($groups==undef and $users==undef and $addresses==undef and $hosts==undef)
  {
    fail('No match criteria found')
  }

  if ! defined(Class['openssh::server'])
  {
    fail('You must include the openssh::server base class before using any openssh::server defined resources')
  }

  concat::fragment { "${openssh::params::sshd_config} match ${name} ${users} ${groups} ${addresses} ${hosts}":
    target  => $openssh::params::sshd_config,
    order   => '95',
    content => template("${module_name}/match/match.erb"),
  }

}
