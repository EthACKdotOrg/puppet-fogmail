class fogmail::role::introducer {
  class {'xtreemfs::role::directory':
    extra => {
      'checksums.enabled'           => 'true',
      'checksums.algorithm'         => 'SHA-1',
      'discover'                    => 'false',
      'ssl.enabled'                 => 'true',
      'ssl.service_creds.container' => 'pkcs12',
      'ssl.service_creds.pw'        => hiera('xstreemfs::service_cred::pwd'),
      'ssl.trusted_certs.container' => 'jks',
      'ssl.trusted_certs.pw'        => hiera('xstreemfs::trusted_cred::pwd'),
    }
  }
  class {'xtreemfs::role::metadata':
    dir_service  => 'localhost',
    extra        => {
      'authentication_provider'     => 'org.xtreemfs.common.auth.SimpleX509AuthProvider',
      'ssl.enabled'                 => 'true',
      'ssl.service_creds.container' => 'pkcs12',
      'ssl.service_creds.pw'        => hiera('xstreemfs::service_cred::pwd'),
      'ssl.trusted_certs.container' => 'jks',
      'ssl.trusted_certs.pw'        => hiera('xstreemfs::trusted_cred::pwd'),
      'startup.wait_for_dir'        => 120,
    },
  }

  Openssl::Export::Pkcs12 {
    ensure  => present,
    basedir => '/etc/xos/xtreemfs/truststore/certs',
  }

  ::openssl::export::pkcs12 {'ds':
    pkey      => '/ssl/certs/ds.key',
    cert      => '/ssl/certs/ds.crt',
    pkey_pass => hiera('xstreemfs::service_cred::pwd'),
    require   => File['/etc/xos/xtreemfs/truststore/certs'],
  }->
  file {'/etc/xos/xtreemfs/truststore/certs/ds.p12':
    ensure => file,
    owner  => 'root',
    group  => 'xtreemfs',
    mode   => '0640',
    notify => Anchor[$xtreemfs::internal::workflow::configure],
  }

  ::openssl::export::pkcs12 {'mrc':
    pkey      => '/ssl/certs/mrc.key',
    cert      => '/ssl/certs/mrc.crt',
    pkey_pass => hiera('xstreemfs::service_cred::pwd'),
    require   => File['/etc/xos/xtreemfs/truststore/certs'],
  }->
  file {'/etc/xos/xtreemfs/truststore/certs/mrc.p12':
    ensure => file,
    owner  => 'root',
    group  => 'xtreemfs',
    mode   => '0640',
    notify => Anchor[$xtreemfs::internal::workflow::configure],
  }

}
