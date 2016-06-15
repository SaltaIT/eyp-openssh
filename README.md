# openssh

![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What postgresql affects](#what-postgresql-affects)
    * [Setup requirements](#setup-requirements)
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
* packages:
  * client package (if not included in server package)
  * server package


### Setup Requirements

This module requires pluginsync enabled

### Beginning with openssh

```puppet
class { 'openssh::client': }

class { 'openssh::server': }
```

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

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
* SLES 11 SP3

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some tests to check both presence and absence of any feature

### TODO

* Move openssh::server configuration options to the **openssh::server** namespace, for example:
  * **openssh::denyuser** -> **openssh::server::denyuser**
* Implement **openssh::client::host** using concat { $openssh::params::ssh_config: }

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
