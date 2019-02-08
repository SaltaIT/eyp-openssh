# CHANGELOG

## 0.1.47

* added SLES 12.4 support

## 0.1.46

* added SLES 12.3 support

## 0.1.45

* added Ubuntu 18.04 support

## 0.1.44

* added **openssh::client::host** defined to configure host based openssh client options
* added the following generic options for **ssh_config**:
  - SendEnv
  - ForwardX11Trusted

## 0.1.43

* added **key_source** to **openssh::privkey**

## 0.1.42

* added **allow_tcp_forwarding** to **openssh::server**

## 0.1.41

* added automatic directive selection (**AuthorizedKeysCommandUser**/**AuthorizedKeysCommandRunAs**) for **CentOS 6/7**

## 0.1.40

* bugfix **authorized_keys_command** in **CentOS 7**

## 0.1.38

* added **authorized_keys_command** variable

## 0.1.37

* **INCOMPATIBLE CHANGE** dropped defines:
  * **openssh::denyuser**
  * **openssh::allowuser**

## 0.1.36

* added user/group access control:
  * deny_users
  * deny_groups
  * allow_users
  * allow_groups

## 0.1.35

* added more sshd variables:
  * kerberos_authentication
  * print_last_log
* added variable to be able to set mode for ssh server key files, default to undef

## 0.1.34

* added more sshd variables:
  * address_family
  * listen_address
  * key_regeneration_interval
  * server_key_bits
  * strict_modes
  * max_sessions
  * max_startups_start
  * max_startups_rate
  * max_startups_full
  * rsa_authentication
  * pubkey_authentication
  * challenge_response_authentication
  * print_motd
* added **password_authentication** to **openssh::match**
* **INCOMPATIBLE CHANGE**: changed default value for **allow_tcp_forwarding** from false to undef in **openssh::match**

## 0.1.33

* added x11uselocalhost to **openssh:server**

## 0.1.32

* added sftp_command to **openssh::server**

## 0.1.31

* ubuntu 16 support

## 0.1.30

* global variable **eypopensshserver::hardening** to enable/disable default hardening (default: false)

## 0.1.29

* rollback secure ciphers & MACs

## 0.1.28

* secure ciphers & MACs
* changed default **ClientAliveCountMax** to **5**

## 0.1.27

* bugfix validate openssh::server

## 0.1.26

* **openssh::server**:
  * rollback enforced secure ciphers - set to undef
  * rollback enforced secure MACs - set to undef

## 0.1.25
* **openssh::server**:
  * rollback 0.1.24 & 0.1.23
  * enforced secure ciphers
  * enforced secure MACs
  * logingracetime set by default to 60

## 0.1.24

* **openssh::server**:
  * changed default **ClientAliveCountMax** to **15**

## 0.1.23

* **openssh::server**:
  * changed default **ClientAliveInterval** to **240**
