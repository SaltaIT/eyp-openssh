class openssh::params {

  $sshd_config='/etc/ssh/sshd_config'
  $ssh_config='/etc/ssh/ssh_config'
  $sshd_config_template='sshd_config.erb'

  $clientaliveinterval_default='300'
  $clientalivecountmax_default='0'

  $logingracetime_default = '60'

  $sshd_ciphers_default=[ 'aes256-ctr', 'aes192-ctr', 'aes128-ctr' ]

  case $::osfamily
  {
    'redhat':
    {
      $package_sshd='openssh-server'

      $sftp_server='/usr/libexec/openssh/sftp-server'
      $package_sftp=undef

      $sshd_service='sshd'

      $package_ssh_client='openssh-clients'

      $syslogfacility_default='AUTHPRIV'

      case $::operatingsystemrelease
      {
        /^[56].*$/:
        {
          # disponibles:
          #
          # hmac-md5,
          # hmac-sha1,
          # umac-64@openssh.com,
          # hmac-ripemd160,
          # hmac-sha1-96,
          # hmac-md5-96

          # hmac-sha2-256,hmac-sha2-512,hmac-sha1
          $sshd_macs_default = [
            'hmac-sha1',
          ]

          # -_(._.)_-
        }
        /^7.*$/:
        {
          $sshd_macs_default = [
            'hmac-sha2-512-etm@openssh.com',
            'hmac-sha2-256-etm@openssh.com',
            'umac-128-etm@openssh.com',
            'hmac-sha2-512',
            'hmac-sha2-256',
            'umac-128@openssh.com',
          ]
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      $package_sshd='openssh-server'

      $sftp_server='/usr/lib/openssh/sftp-server'
      $package_sftp='openssh-sftp-server'

      $sshd_service='ssh'

      $package_ssh_client='openssh-client'

      $syslogfacility_default='AUTH'

      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $sshd_macs_default = [
                'hmac-sha2-512-etm@openssh.com',
                'hmac-sha2-256-etm@openssh.com',
                'umac-128-etm@openssh.com',
                'hmac-sha2-512',
                'hmac-sha2-256',
                'umac-128@openssh.com',
              ]
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    'Suse':
    {
      $package_sshd='openssh'

      case $::operatingsystem
      {
        'SLES':
        {
          case $::operatingsystemrelease
          {
            '11.3':
            {
              $sftp_server='/usr/lib/ssh/sftp-server'
              $package_sftp=undef

              $sshd_service='sshd'

              $package_ssh_client=undef

              $syslogfacility_default='AUTH'
            }
            default: { fail("Unsupported operating system ${::operatingsystem} ${::operatingsystemrelease}") }
          }
        }
        default: { fail("Unsupported operating system ${::operatingsystem}") }
      }
    }

    default: { fail('Unsupported OS!')  }
  }
}
