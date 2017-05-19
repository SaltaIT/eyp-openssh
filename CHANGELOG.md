# CHANGELOG

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
