class fogmail::role::introducer {

  $creds_base = '/etc/xos/xtreemfs/truststore'


  class {'::fogstore':
    client_ca           => 'ca/client-ca.crt',
    client_jks_password => hiera('xtreemfs::trusted_client::pwd'),
    cred_certs          => {
      dir               => "certs/dir-${hostname}-dir.crt",
      mrc               => "certs/mrc-${hostname}-mrc.crt",
    },
    cred_keys => {
      dir     => "certs/${hostname}-dir.key",
      mrc     => "certs/${hostname}-mrc.key",
    },
    dir_ca           => 'ca/dir-ca.crt',
    dir_jks_password => hiera('xtreemfs::trusted_dir::pwd'),
    cred_password    => hiera('xtreemfs::service_cred::pwd'),
    mrc_ca           => 'ca/mrc-ca.crt',
    mrc_jks_password => hiera('xtreemfs::trusted_mrc::pwd'),
    osd_ca           => 'ca/osd-ca.crt',
    osd_jks_password => hiera('xtreemfs::trusted_osd::pwd'),
    role             => 'introducer',
    ssl_source_dir   => '/vagrant/puppet',
    trusted_password => hiera('xtreemfs::trusted_cred::pwd'),
  }
}
