class fogmail::role::introducer {

  $ssl_base = '/vagrant/puppet'

  $creds_base = '/etc/xos/xtreemfs/truststore'
  
  class {'xtreemfs::role::directory':
    properties => {
      'checksums.enabled'           => 'true',
      'checksums.algorithm'         => hiera('xtreemfs::checksums::algo'),
      'discover'                    => 'false',
      'ssl.enabled'                 => 'true',
      'ssl.service_creds'           => "${creds_base}/dir.p12",
      'ssl.service_creds.container' => 'pkcs12',
      'ssl.service_creds.pw'        => hiera('xtreemfs::service_cred::pwd'),
      'ssl.trusted_certs'           => "${creds_base}/dir.jks",
      'ssl.trusted_certs.container' => 'jks',
      'ssl.trusted_certs.pw'        => hiera('xtreemfs::trusted_cred::pwd'),
    }
  }
  class {'xtreemfs::role::metadata':
    dir_service  => 'localhost',
    properties   => {
      'authentication_provider'     => 'org.xtreemfs.common.auth.SimpleX509AuthProvider',
      'admin_passowrd'              => hiera('xtreemfs::admin_password'),
      'ssl.enabled'                 => 'true',
      'ssl.service_creds'           => "${creds_base}/mrc.p12",
      'ssl.service_creds.container' => 'pkcs12',
      'ssl.service_creds.pw'        => hiera('xtreemfs::service_cred::pwd'),
      'ssl.trusted_certs'           => "${creds_base}/mrc.jks",
      'ssl.trusted_certs.container' => 'jks',
      'ssl.trusted_certs.pw'        => hiera('xtreemfs::trusted_cred::pwd'),
      'startup.wait_for_dir'        => 120,
    },
  }

  include ::fogmail::xtreemfs::servers

  Openssl::Export::Pkcs12 {
    ensure  => present,
    basedir => $creds_base,
  }

  ::openssl::export::pkcs12 {'dir':
    pkey      => "${ssl_base}/ssl/certs/${::hostname}-dir.key",
    cert      => "${ssl_base}/ssl/certs/${::hostname}-dir.crt",
    chaincert => "${ssl_base}/ssl/ca/common-ca-chain.pem",
    out_pass  => hiera('xtreemfs::service_cred::pwd'),
    require   => File[$creds_base],
  }->
  file {"${creds_base}/dir.p12":
    ensure => file,
    owner  => 'root',
    group  => 'xtreemfs',
    mode   => '0640',
    notify => Anchor[$xtreemfs::internal::workflow::configure],
  }

  ::openssl::export::pkcs12 {'mrc':
    pkey      => "${ssl_base}/ssl/certs/${::hostname}-mrc.key",
    cert      => "${ssl_base}/ssl/certs/${::hostname}-mrc.crt",
    chaincert => "${ssl_base}/ssl/ca/common-ca-chain.pem",
    out_pass  => hiera('xtreemfs::service_cred::pwd'),
    require   => File[$creds_base],
  }->
  file {"${creds_base}/mrc.p12":
    ensure => file,
    owner  => 'root',
    group  => 'xtreemfs',
    mode   => '0640',
    notify => Anchor[$xtreemfs::internal::workflow::configure],
  }

}
