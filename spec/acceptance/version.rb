
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $packagename     = 'openssh-server'
  $servicename     = 'sshd'

when 'Debian'
  $packagename     = 'openssh-server'
  $servicename     = 'ssh'

else
  $packagename     = '-_-'
  $servicename     = '-_-'

end
