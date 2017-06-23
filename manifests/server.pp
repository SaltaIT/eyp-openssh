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
# (...)
# 95 - Match directives
#
class openssh::server (
                        $port                              = '22',
                        $permitrootlogin                   = 'no',
                        $usedns                            = false,
                        $usepam                            = true,
                        $x11forwarding                     = false,
                        $passwordauth                      = true,
                        $permitemptypasswords              = false,
                        $enableldapsshkeys                 = false,
                        $syslogfacility                    = $openssh::params::syslogfacility_default,
                        $banner                            = undef,
                        $allowusers                        = undef,
                        $denyusers                         = undef,
                        $ensure                            = 'running',
                        $manage_service                    = true,
                        $manage_docker_service             = true,
                        $enable                            = true,
                        $clientaliveinterval               = $openssh::params::clientaliveinterval_default,
                        $clientalivecountmax               = $openssh::params::clientalivecountmax_default,
                        $log_level                         = 'INFO',
                        $ignore_rhosts                     = true,
                        $hostbased_authentication          = false,
                        $maxauthtries                      = '4',
                        $permit_user_environment           = false,
                        $ciphers                           = $openssh::params::sshd_ciphers_default,
                        $macs                              = $openssh::params::sshd_macs_default,
                        $logingracetime                    = '60',
                        $sftp_command                      = $openssh::params::sftp_server,
                        $x11uselocalhost                   = false,
                        $address_family                    = 'any',
                        $listen_address                    = [ '0.0.0.0' ],
                        $key_regeneration_interval         = '1h',
                        $server_key_bits                   = '1024',
                        $strict_modes                      = true,
                        $max_sessions                      = '10',
                        $max_startups_start                = '10',
                        $max_startups_rate                 = '30',
                        $max_startups_full                 = '100',
                        $rsa_authentication                = true,
                        $pubkey_authentication             = true,
                        $challenge_response_authentication = false,
                        $print_motd                        = true,
                        $kerberos_authentication           = false,
                        $print_last_log                    = true,
                        $ssh_server_keys_mode              = undef,
                        $ssh_server_keys_filenames         = [
                                                              '/etc/ssh/ssh_host_ecdsa_key',
                                                              '/etc/ssh/ssh_host_ed25519_key',
                                                              '/etc/ssh/ssh_host_rsa_key'
                                                              ],
                      )inherits openssh::params {

  if($ciphers!=undef)
  {
    validate_array($ciphers)
  }

  if($macs!=undef)
  {
    validate_array($macs)
  }

  if($allowusers!=undef)
  {
    validate_array($allowusers)
  }

  if($denyusers!=undef)
  {
    validate_array($denyusers)
  }

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

    $require_packages=Package[ [ $openssh::params::package_sshd, $openssh::params::package_sftp ] ]
  }
  else
  {
    $require_packages=Package[$openssh::params::package_sshd]
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
                  $require_packages,
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

  if($ssh_server_keys_mode!=undef)
  {
    file { $ssh_server_keys_filenames:
      ensure => 'present',
      mode   => $ssh_server_keys_mode,
    }
  }

}
