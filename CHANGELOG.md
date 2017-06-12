# CHANGELOG

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
