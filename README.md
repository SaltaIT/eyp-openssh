# openssh

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What postgresql affects](#what-postgresql-affects)
    * [Beginning with postgresql](#beginning-with-postgresql)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
    * [TODO](#todo)
    * [Contributing](#contributing)

## Overview

openssh management

## Module Description

openssh client and server management

## Setup

### What openssh affects

Manages:
* files:
  * **/etc/ssh/sshd_config**
  * **/etc/ssh/ssh_config**
  * On **RHEL 8** file **/etc/sysconfig/sshd** is also managed
* packages:
  * client package (if not included in server package)
  * server package

### Beginning with openssh

```puppet
class { 'openssh::client': }

class { 'openssh::server': }
```

## Usage

### Cyphers / MACs hardening

global variable **eypopensshserver::hardening** to enable/disable default hardening (default: false)

### manage user's priv keys

```puppet
class { 'openssh': }
class { 'openssh::server': }
class { 'openssh::client': }

openssh::privkey { 'postgres':
  homedir => '/var/lib/pgsql',
}
```

### matchers

```puppet
openssh::match{'chroot':
  groups => [ 'sftp' ],
  forcecommand => 'internal-sftp',
  chrootdirectory => '%h',
}
```

### allow/deny users

```puppet
openssh::denyuser { 'loluser': }
openssh::denyuser { 'loluser2': }

openssh::allowuser { 'allowuser5': }
openssh::allowuser { 'allowuser6': }
```
### using openssh::server's array

```puppet
class { 'openssh::server':
  denyusers => [ 'loluser3', 'loluser4' ],
  allowusers => [ 'root', 'ggg', 'kk', 'rrr' ],
  enableldapsshkeys => false,
}
```

### Restric login per user to a given set of IPs

```puppet
openssh::match{ 'users ips allowed':
  users => [ 'ada', 'ualoc' ],
  allowed_ips => [ '1.2.3.4', '5.6.7.8', '1.1.1.1' ],
}
```

This will generate the following config in sshd_config:

```
Match  user ada,ualoc
  AllowTcpForwarding no
  AllowUsers ada@1.2.3.4
  AllowUsers ada@5.6.7.8
  AllowUsers ada@1.1.1.1
  AllowUsers ualoc@1.2.3.4
  AllowUsers ualoc@5.6.7.8
  AllowUsers ualoc@1.1.1.1
```

## Reference

### global variables:

* **eypopensshserver::hardening**: to manage default hardening of Cyphers and MACs (default: false)

### classes

#### openssh

empty class - just a placeholder

#### openssh::client

Most variables are standard postfix variables, please refer to postfix documentation for further detaisl:

* **gssapi_authentication**: (default: true)

#### openssh::server

Most variables are standard postfix variables, please refer to ssh documentation for further detaisl:

* **ensure**: service's ensure (default: running)
* **manage_service** (default: true)
* **manage_docker_service** (default: true)
* **enable** (default: true)
* **port**: (default: 22)
* **permitrootlogin**: (default: no)
* **usedns** (default: false)
* **usepam** (default: true)
* **x11forwarding** (default: false)
* **passwordauth** (default: true)
* **permitemptypasswords** (default: false)
* **enableldapsshkeys** (default: false)
* **syslogfacility**           
* **banner** (default: undef)
* **clientaliveinterval** (default: 900)
* **clientalivecountmax** (default: 0)
* **log_level** (default: INFO)
* **ignore_rhosts** (default: true)
* **hostbased_authentication** (default: false)
* **maxauthtries** (default: 4)
* **permit_user_environment** (default: false)
* **allowusers**: (order: DenyUsers, AllowUsers, default: undef)
* **denyusers**: (order: DenyUsers, AllowUsers, default: undef)
* **x11uselocalhost** (default: false)

#### openssh::service

private class to manage **openssh::server**'s service

### defines

#### openssh::allowuser
* **username** (default: resource's name)

#### openssh::denyuser
* **username** (default: resource's name)

####  openssh::match
* matchers (**at least one must be set**):
  * **groups** (default: undef)
  * **users** (default: undef)
  * **addresses** (default: undef)
  * **hosts** (default: undef)
* **chrootdirectory**: It might not be supported (default: undef)
* **forcecommand**: (default: undef)
* **allow_tcp_forwarding** (default: false)
* **allowed_ips**: list of allowed IPs for this user (default: undef)

####  openssh::privkey
* **ensure**     (default: present)
* **user**       = $name,
* **group**      = $name,
* **homedir**    = "/home/${name}",
* **type**      (default: rsa)
* **passphrase** (default: '')

## Limitations

Tested on:
* CentOS 5
* CentOS 6
* CentOS 7
* Ubuntu 14.04
* Ubuntu 16.04
* SLES 11 SP3

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some tests to check both presence and absence of any feature

### TODO

* Move openssh::server configuration options to the **openssh::server** namespace, for example:
  * **openssh::denyuser** -> **openssh::server::denyuser**

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
