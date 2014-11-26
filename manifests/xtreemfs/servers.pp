class fogmail::xtreemfs::servers {
  
  $ssl_base = '/vagrant/puppet'
  $ks_base = '/etc/xos/xtreemfs/truststore'

  File <| tag == 'cacert' |> -> Java_ks <||>

  file {'/etc/xos/xtreemfs/truststore':
    ensure  => directory,
    owner   => 'root',
    group   => 'xtreemfs',
    mode    => '0750',
    require => Anchor[$xtreemfs::internal::workflow::packages],
    tag     => 'cacert',
  }

  java_ks {'xtreemfs_mrc:client':
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/client-ca-chain.pem",
    target       => "${ks_base}/mrc.jks",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
  
  java_ks {"ks_common_mrc:${ks_base}/mrc.jks":
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/common-ca-chain.pem",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
  
  java_ks {'xtreemfs_dir:osd':
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/osd-ca-chain.pem",
    target       => "${ks_base}/dir.jks",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  java_ks {"ks_common_dir:${ks_base}/dir.jks":
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/common-ca-chain.pem",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  java_ks {'xtreemfs:all':
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/common-ca-chain.pem",
    target       => "${ks_base}/all.jks",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
  }

  java_ks {"all_client:${ks_base}/all.jks":
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/client-ca-chain.pem",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
  }

  java_ks {"all_osd:${ks_base}/all.jks":
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/osd-ca-chain.pem",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
  }
}
