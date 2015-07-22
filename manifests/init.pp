class autofs {

  file { '/etc/nsswitch.conf':
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  case $::operatingsystem {
    centos, rhel, fedora: {
      case $::operatingsystemmajrelease {
        5, 6: {
          service { autofs:
            ensure    => running,
            enable    => true,
            subscribe => File["/etc/nsswitch.conf"],
          }
        }
  /* But wait! Why do you have to specify the systemd provider here?
     Shouldn't it Just Work on CentOS 7 and Fedora 22+?

     yes. yes, it should, and it does on CentOS 7. On Fedora 22 it fails
     miserably:

puppet-agent[22751]: (/Stage[main]/Autofs/Service[autofs]/enable) change from false to true failed: Could not enable autofs: Execution of '/sbin/chkconfig --add autofs' returned 1: error reading information on service autofs: No such file or directory

          Your Earth logic is useless here! Mwahahahaha! */

        default: {
          service { autofs:
            provider   => 'systemd',
            name       => 'nfs-server',
            ensure     => running,
            enable     => true,
            hasrestart => true,
            hasstatus  => true,
            subscribe => File["/etc/nsswitch.conf"],
          }
        }
      }
    }
    default: {
      service { autofs:
        ensure    => running,
        enable    => true,
        subscribe => File["/etc/nsswitch.conf"],
      }
    }
  }
}
