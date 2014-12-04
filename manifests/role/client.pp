class fogmail::role::client {

  $ssl_base = '/vagrant/puppet'

  $admin_password = hiera('xtreemfs::admin_password')
  $pkcs_password  = hiera('xtreemfs::service_cred::pwd')
  $dir_service    = hiera('xtreemfs::settings::dir_server')
  $encfs_password = hiera('fogmail::encfs_password')


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
  }->
  ::xtreemfs::volume {'vmail':
    ensure      => present,
    dir_service => "pbrpcs://${dir_service}",
    options     => {
      '-s'                  => 64,
      '-w'                  => 3,
      '--admin_password' => hiera('xtreemfs::admin_password'),
      '--pkcs12-file-path'  => '/etc/ssl/certs/xtreemfs-client.p12',
      '--pkcs12-passphrase' => hiera('xtreemfs::service_cred::pwd'),
    },
  }->
  file {'/srv/encrypted':
    ensure => directory,
    #owner  => 'vmail',
    #group  => 'vmail',
  }->
#  ::xtreemfs::mount {'/srv/crypted':
#    ensure      => mounted,
#    volume      => 'vmail',
#    dir_service => $dir_service,
#  }->
#  ::xtreemfs::policy {'/srv/encrypted':
#    policy => 'WqRq',
#    factor => 4,
#  }

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
