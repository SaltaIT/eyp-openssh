#
class openssh::client() inherits openssh::params {

  package { $openssh::params::package_ssh_client:
      ensure => 'installed',
  }

}
