class fogmail::role::storage {
  class {'xtreemfs::role::storage':
    dir_service => hiera('xstreemfs::settings::dir_server'),
    object_dir  => '/mnt/xtreemfs',
    properties  => {
      'report_free_space'           => 'true',
      'checksums.enabled'           => 'true',
      'checksums.algorithm'         => 'SHA-1',
      'ssl.enabled'                 => 'true',
      'ssl.service_creds.container' => 'pkcs12',
      'ssl.service_creds.pw'        => hiera('xstreemfs::service_cred::pwd'),
      'ssl.trusted_certs.container' => 'jks',
      'ssl.trusted_certs.pw'        => hiera('xstreemfs::trusted_cred::pwd'),
      'startup.wait_for_dir'        => 120,
    }
  }

  ::openssl::export::pkcs12 {'osd':
    ensure    => present,
    basedir   => '/etc/xos/xtreemfs/truststore/certs',
    pkey      => '/ssl/certs/osd.key',
    cert      => '/ssl/certs/osd.crt',
    pkey_pass => hiera('xstreemfs::service_cred::pwd'),
    require   => File['/etc/xos/xtreemfs/truststore/certs'],
  }->
  file {'/etc/xos/xtreemfs/truststore/certs/osd.p12':
    ensure => file,
    owner  => 'root',
    group  => 'xtreemfs',
    mode   => '0640',
    notify => Anchor[$xtreemfs::internal::workflow::configure],
  }
}
