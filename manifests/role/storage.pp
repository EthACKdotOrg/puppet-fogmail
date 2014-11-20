class fogmail::role::storage {
  class {'xtreemfs::role::storage':
    dir_service => hiera('xstreemfs::settings::dir_server'),
    object_dir  => '/mnt/xtreemfs',
    extra       => {
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

  file {'/etc/xos/xtreemfs/truststore/certs/osd.p12':
    ensure => file,
    owner  => 'root',
    group  => 'xtreemfs',
    mode   => '0640',
    source => '/ssl/xtreemfs/storage.p12',
    notify => Anchor[$xtreemfs::internal::workflow::configure],
  }
}
