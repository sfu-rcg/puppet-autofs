class autofs {

  service { autofs:
    enable => true,
    ensure => running,
    subscribe => File["/etc/nsswitch.conf"],
  }

  file { "/etc/nsswitch.conf":
    owner => "root",
    group => "root",
    mode => "0644",
  }
}
