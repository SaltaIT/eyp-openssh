class openssh::params {

  $sshd_config='/etc/ssh/sshd_config'
  $sshd_config_template='sshd_config.erb'

  $package_sshd='openssh-server'

	case $::osfamily
	{
		'redhat':
    {
      case $::operatingsystemrelease
      {
        /^6.*$/:
        {
          $sftp_server='/usr/libexec/openssh/sftp-server'
          $package_sftp='openssh-server'

          $sshd_service='sshd'
        }
        default: { fail("Unsupported RHEL/CentOS version! - $::operatingsystemrelease")  }
      }
    }
		'Debian':
		{
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
						}
						default: { fail("Unsupported Ubuntu version! - $::operatingsystemrelease")  }
					}
				}
				'Debian': { fail("Unsupported")  }
				default: { fail("Unsupported Debian flavour!")  }
			}
		}
		default: { fail("Unsupported OS!")  }
	}
}
