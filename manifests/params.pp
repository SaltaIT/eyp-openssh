class openssh::params {

  $sshd_config='/etc/ssh/sshd_config'
  $ssh_config='/etc/ssh/ssh_config'
  $sshd_config_template='sshd_config.erb'

  $clientaliveinterval_default='300'
  $clientalivecountmax_default='5'

  if(hiera('eypopensshserver::hardening', false))
  {
    $sshd_ciphers_default = [ 'aes256-ctr', 'aes192-ctr', 'aes128-ctr' ]
  }
  else
  {
    $sshd_ciphers_default = undef
  }


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

      case $::operatingsystem
      {
        'RedHat':
        {

          case $::operatingsystemrelease
          {
            /^[56].*$/:
            {
              # disponibles:
              #
              # RHEL 6
              # hmac-md5,
              # hmac-sha1,
              # umac-64@openssh.com,
              # hmac-ripemd160,
              # hmac-sha1-96,
              # hmac-md5-96,
              # * hmac-sha2-256,
              # * hmac-sha2-512,
              # hmac-ripemd160@openssh.com

              if(hiera('eypopensshserver::hardening', false))
              {
                $sshd_macs_default = [
                  'hmac-sha2-256',
                  'hmac-sha2-512',
                ]
              }
              else
              {
                $sshd_macs_default = undef
              }


              # -_(._.)_-
            }
            /^7.*$/:
            {
              # RHEL 7

              # hmac-md5-etm@openssh.com,
              # hmac-sha1-etm@openssh.com,
              # umac-64-etm@openssh.com,
              # * umac-128-etm@openssh.com,
              # * hmac-sha2-256-etm@openssh.com,
              # * hmac-sha2-512-etm@openssh.com,
              # hmac-ripemd160-etm@openssh.com,
              # hmac-sha1-96-etm@openssh.com,
              # hmac-md5-96-etm@openssh.com,
              # hmac-md5,
              # hmac-sha1,
              # umac-64@openssh.com,
              # * umac-128@openssh.com,
              # * hmac-sha2-256,
              # * hmac-sha2-512,
              # hmac-ripemd160,
              # hmac-sha1-96,
              # hmac-md5-96

              if(hiera('eypopensshserver::hardening', false))
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
              else
              {
                $sshd_macs_default = undef
              }
            }
            default: { fail("Unsupported RHEL version! - ${::operatingsystemrelease}")  }
          }
        }
        default:
        {
          case $::operatingsystemrelease
          {
            /^[56].*$/:
            {
              # disponibles:
              #
              # CentOS 6
              # hmac-md5,
              # hmac-sha1,
              # umac-64@openssh.com,
              # hmac-ripemd160,
              # hmac-sha1-96,
              # hmac-md5-96

              # hmac-sha2-256,hmac-sha2-512,hmac-sha1

              if(hiera('eypopensshserver::hardening', false))
              {
                $sshd_macs_default = [
                  'hmac-sha1',
                ]
              }
              else
              {
                $sshd_macs_default = undef
              }


              # -_(._.)_-
            }
            /^7.*$/:
            {
              # CentOS

              # hmac-md5-etm@openssh.com,hmac-sha1-etm@openssh.com,
              # umac-64-etm@openssh.com,umac-128-etm@openssh.com,
              # hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,
              # hmac-ripemd160-etm@openssh.com,hmac-sha1-96-etm@openssh.com,
              # hmac-md5-96-etm@openssh.com,
              # hmac-md5,hmac-sha1,umac-64@openssh.com,umac-128@openssh.com,
              # hmac-sha2-256,hmac-sha2-512,hmac-ripemd160,
              # hmac-sha1-96,hmac-md5-96

              if(hiera('eypopensshserver::hardening', false))
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
              else
              {
                $sshd_macs_default = undef
              }

            }
            default: { fail("Unsupported CentOS version! - ${::operatingsystemrelease}")  }
          }
        }
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
            /^1[46].*$/:
            {

              if(hiera('eypopensshserver::hardening', false))
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
              else
              {
                $sshd_macs_default = undef
              }
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

              if(hiera('eypopensshserver::hardening', false))
              {
                $sshd_macs_default = undef
              }
              else
              {
                $sshd_macs_default = undef
              }
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
