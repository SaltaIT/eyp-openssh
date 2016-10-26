class openssh::params {

  $sshd_config='/etc/ssh/sshd_config'
  $ssh_config='/etc/ssh/ssh_config'
  $sshd_config_template='sshd_config.erb'

  $clientaliveinterval_default='240'
  $clientalivecountmax_default='15'

  case $::osfamily
  {
    'redhat':
    {
      $package_sshd='openssh-server'

      case $::operatingsystemrelease
      {
        /^[5-7].*$/:
        {
          $sftp_server='/usr/libexec/openssh/sftp-server'
          $package_sftp=undef

          $sshd_service='sshd'

          $package_ssh_client='openssh-clients'

          $syslogfacility_default='AUTHPRIV'
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      $package_sshd='openssh-server'

      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $sftp_server='/usr/lib/openssh/sftp-server'
              $package_sftp='openssh-sftp-server'

              $sshd_service='ssh'

              $package_ssh_client='openssh-client'

              $syslogfacility_default='AUTH'
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
