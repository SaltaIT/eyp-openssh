define openssh::client::host(
                              $host                  = $name,
                              $description           = undef,
                              $gssapi_authentication = true,
                              $check_host_ip         = true,
                              $order                 = '00',
                            ) {
  include ::openssh::client

  concat::fragment { "${openssh::params::ssh_config} host ${host} ${name}":
    target  => $openssh::params::ssh_config,
    order   => "10_${order}",
    content => template("${module_name}/ssh_config/host.erb"),
  }
}
