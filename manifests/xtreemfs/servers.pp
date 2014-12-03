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

  ## MRC jks: trusts client-ca, dir-ca
  java_ks {'mrc_client_ca':
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/client-ca.crt",
    target       => "${ks_base}/mrc.jks",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
  
  java_ks {"mrc_dir_ca:${ks_base}/mrc.jks":
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/dir-ca.crt",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
  
  ## DIR jks: trusts client-ca, mrc-ca, osd-ca
  java_ks {'dir_client_ca':
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/client-ca.crt",
    target       => "${ks_base}/dir.jks",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  java_ks {"dir_mrc_ca:${ks_base}/dir.jks":
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/mrc-ca.crt",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  java_ks {"dir_osd_ca:${ks_base}/dir.jks":
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/osd-ca.crt",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  ## OSD jks: trusts client-ca, dir-ca
  java_ks {'osd_client_ca':
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/client-ca.crt",
    target       => "${ks_base}/osd.jks",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
  
  java_ks {"osd_dir_ca:${ks_base}/osd.jks":
    ensure       => latest,
    certificate  => "${ssl_base}/ssl/ca/dir-ca.crt",
    password     => hiera('xtreemfs::trusted_cred::pwd'),
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
}
