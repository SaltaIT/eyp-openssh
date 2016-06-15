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

openssh client and server management

## Module Description

If applicable, this section should have a brief description of the technology
the module integrates with and what that integration enables. This section
should answer the questions: "What does this module *do*?" and "Why would I use
it?"

If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup

### What openssh affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

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

### openssh::client

### openssh::server
* **allowusers**: (order: DenyUsers, AllowUsers, default: undef)
* **denyusers**: (order: DenyUsers, AllowUsers, default: undef)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some tests to check both presence and absence of any feature

### TODO

* Move openssh::server configuration options to the openssh::server namespace, for example:
  * openssh::denyuser -> openssh::server::denyuser
* Implement openssh::client::host using concat { $openssh::params::ssh_config: }

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
