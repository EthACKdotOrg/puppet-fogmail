class fogmail::role::storage {

  $ssl_base = '/vagrant/puppet'
  $creds_base = '/etc/xos/xtreemfs/truststore'

  class {'xtreemfs::role::storage':
    dir_service => hiera('xtreemfs::settings::dir_server'),
    object_dir  => '/mnt/xtreemfs',
    properties  => {
      'report_free_space'           => 'true',
      'checksums.enabled'           => 'true',
      'checksums.algorithm'         => hiera('xtreemfs::checksums::algo'),
      'ssl.enabled'                 => 'true',
      'ssl.service_creds'           => "${creds_base}/osd.p12",
      'ssl.service_creds.container' => 'pkcs12',
      'ssl.service_creds.pw'        => hiera('xtreemfs::service_cred::pwd'),
      'ssl.trusted_certs'           => "${creds_base}/dir.jks",
      'ssl.trusted_certs.container' => 'jks',
      'ssl.trusted_certs.pw'        => hiera('xtreemfs::trusted_cred::pwd'),
      'startup.wait_for_dir'        => 120,
    }
  }

  include ::fogmail::xtreemfs::servers

  ::openssl::export::pkcs12 {'osd':
    ensure    => present,
    basedir   => $creds_base,
    pkey      => "${ssl_base}/ssl/certs/${::hostname}.key",
    cert      => "${ssl_base}/ssl/certs/${::hostname}.crt",
    chaincert => "${ssl_base}/ssl/ca/osd-ca-chain.pem",
    out_pass  => hiera('xtreemfs::service_cred::pwd'),
    require   => File[$creds_base],
  }->
  file {"${creds_base}/osd.p12":
    ensure => file,
    owner  => 'root',
    group  => 'xtreemfs',
    mode   => '0640',
    notify => Anchor[$xtreemfs::internal::workflow::configure],
  }
}
