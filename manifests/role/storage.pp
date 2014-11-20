class fogmail::role::storage {
  class {'xtreemfs::role::storage':
    dir_service => hiera('xstreemfs::dir_server'),
    object_dir  => '/mnt/xtreemfs',
    extra       => {
      'report_free_space'           => 'true',
      'ssl.enabled'                 => 'true',
      'ssl.service_creds.container' => 'pkcs12',
      'ssl.service_creds.pw'        => hiera('xstreemfs::service_cred::pwd'),
      'ssl.trusted_certs.container' => 'jks',
      'ssl.trusted_certs.pw'        => hiera('xstreemfs::trusted_cred::pwd'),
      'startup.wait_for_dir'        => 120,
    }
  }

  file {'/etc/xos/xtreemfs/truststore/certs/osd.p12':
  }

  file {'/etc/xos/xtreemfs/truststore/certs/xosrootca.jks':
  }
}
