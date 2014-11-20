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

  file {'/etc/xos/xtreemfs/truststore/certs/ds.p12':
    ensure => file,
    owner  => 'root',
    group  => 'xtreemfs',
    mode   => '0640',
    source => '/ssl/xtreemfs/introducer.p12',
    notify => Anchor[$xtreemfs::internal::workflow::configure],
  }

  file {'/etc/xos/xtreemfs/truststore/certs/mrc.p12':
    ensure => file,
    owner  => 'root',
    group  => 'xtreemfs',
    mode   => '0640',
    source => '/ssl/xtreemfs/introducer.p12',
    notify => Anchor[$xtreemfs::internal::workflow::configure],
  }

}
