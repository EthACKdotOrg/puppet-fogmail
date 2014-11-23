class fogmail::scripts {

  # startup script for docker
  file {'/usr/local/sbin/startall':
    ensure => file,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/fogmail/scripts/startall',
  }

  # Replication stuff
  @file {'/usr/local/bin/replication-bootstrap':
    ensure  => file,
    mode    => '0700',
    owner   => 'postgres',
    group   => 'postgres',
    require => Class['postgresql::server'],
    source  => 'puppet:///modules/fogmail/scripts/replication-bootstrap',
  }
}
