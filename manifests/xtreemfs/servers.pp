class fogmail::xtreemfs::servers {
  file {'/etc/xos/xtreemfs/truststore':
    ensure  => directory,
    owner   => 'root',
    group   => 'xtreemfs',
    mode    => '0750',
    require => Anchor[$xtreemfs::internal::workflow::packages],
  }->
  file {'/etc/xos/xtreemfs/truststore/certs':
    ensure  => directory,
    owner   => 'root',
    group   => 'xtreemfs',
    mode    => '0750',
  }->
  java_ks {'xtreemfs:bundle':
    ensure       => latest,
    certificate  => '/ssl/ca/sub-ca-chain.pem',
    target       => '/etc/xos/xtreemfs/truststore/certs/trusted.jks',
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
}
