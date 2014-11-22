class fogmail::role::client {

  $ssl_base = '/vagrant/puppet'

  package {'xtreemfs-client':
    require => Apt::Source['xtreemfs'],
  }->
  user {'xtreemfs':
    ensure => present,
    system => true,
    shell  => '/bin/false',
  }->
  ::openssl::export::pkcs12 {'xtreemfs-client':
    ensure    => present,
    basedir   => '/etc/ssl/certs',
    cert      => "${ssl_base}/ssl/certs/client.crt",
    pkey      => "${ssl_base}/ssl/certs/client.key",
    chaincert => '/ssl/ca/sub-ca-chain.pem',
    out_pass  => hiera('xtreemfs::service_cred::pwd'),
  }->
  file {'/etc/ssl/private/xtreemfs-client.p12':
    ensure => file,
    owner  => 'xtreemfs',
    group  => 'xtreemfs',
    mode   => '0644',
  }

  $admin_password = hiera('xtreemfs::admin_password')
  $pkcs_password  = hiera('xtreemfs::service_cred::pwd')
  $dir_service    = hiera('xtreemfs::settings::dir_server')
  $encfs_password = hiera('fogmail::encfs_password')

  file {'/srv/encfs':
    ensure => directory,
  }

  package {'encfs': }

  file {'/usr/local/sbin/xtreem-prepare':
    ensure  => file,
    group   => 'root',
    mode    => '0700',
    owner   => 'root',
    content => template('fogmail/xtreemfs/prepare.erb'),
  }

  file {'/usr/local/sbin/xtreem-mount':
    ensure  => file,
    group   => 'root',
    mode    => '0700',
    owner   => 'root',
    content => template('fogmail/xtreemfs/mount.erb'),
  }
}
