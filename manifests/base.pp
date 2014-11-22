class fogmail::base(
  $role,
) {

  include ::fogmail::apt

  if $::debug == 1 {
    include ::fogmail::debug
  }

  sudo::conf {'vagrant-all':
    content => 'vagrant ALL=(ALL) NOPASSWD:ALL',
  }

  # SSH service
  class {'::ssh':
    storeconfigs_enabled       => false,
    server_options             => {
      'PasswordAuthentication' => 'no',
      'PermitRootLogin'        => 'without-password',
      'X11Forwarding'          => 'no',
    },
  }

  class {'::sudo': }
  class {'::ntp':
    restrict => ['127.0.0.1'],
  }

  # install cron/anacron in order to get some
  # periodic tasks, such as system updates, filter
  # updates for SA and so on
  package {['cron', 'anacron']: }

  file {'/etc/profile.d/ps1.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('fogmail/ps1.erb'),
  }

  class {'::xtreemfs::settings':
    add_repo => false,
    require  => Apt::Source['xtreemfs'],
  }

  file {"/etc/default/fogmail_${role}":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  class {"::fogmail::role::${role}":
    require => Class['fogmail::apt'],
  }

  package {'xtreemfs-tools':
    require => Class['fogmail::apt'],
  }

}
