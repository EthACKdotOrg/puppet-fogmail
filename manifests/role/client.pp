class fogmail::role::client {

  $ssl_base = '/vagrant/puppet'

  user {'xtreemfs':
    ensure => present,
    system => true,
    shell  => '/bin/false',
  }->
  ::openssl::export::pkcs12 {'xtreemfs-client':
    ensure    => present,
    basedir   => '/etc/ssl/certs',
    cert      => "${ssl_base}/ssl/certs/client-${::hostname}.crt",
    pkey      => "${ssl_base}/ssl/certs/${::hostname}.key",
    out_pass  => hiera('xtreemfs::service_cred::pwd'),
  }->
  file {'/etc/ssl/certs/xtreemfs-client.p12':
    ensure => file,
    owner  => 'xtreemfs',
    group  => 'xtreemfs',
    mode   => '0644',
  }

  $admin_password = hiera('xtreemfs::admin_password')
  $pkcs_password  = hiera('xtreemfs::service_cred::pwd')
  $dir_service    = hiera('xtreemfs::settings::dir_server')
  $encfs_password = hiera('fogmail::encfs_password')


  $dir = hiera('xtreemfs::settings::dir_server')
  ::xtreemfs::volume {'vmail':
    ensure      => present,
    dir_service => "pbrpcs://${dir}",
    options     => {
      '--admin_password' => hiera('xtreemfs::admin_password'),
      '--pkcs12-file-path'  => '/etc/ssl/certs/xtreemfs-client.p12',
      '--pkcs12-passphrase' => hiera('xtreemfs::service_cred::pwd'),
      '-s'                  => 64,
      '-w'                  => 3,
    },
  }

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
