class autofs {

  if $::operatingsystem == 'ubuntu' and $::operatingsystemrelease == '15.04' {
    file { "/etc/init.d/autofs":
      ensure => absent
    }
    file { "/etc/systemd/system/autofs.service":
      ensure  => present,
      content => template('autofs/autofs.service.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => "0644",
      notify  => [ Service['autofs'], Exec['autofs-systemctl-daemon-reload'] ],
    }
    exec { 'autofs-systemctl-daemon-reload':
      command => 'systemctl daemon-reload',
      path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
      refreshonly => true,
    }
  }

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
