class fogmail::mailserver::setup {

  $ssl_base = '/vagrant/puppet'
  
  file {'/etc/dovecot':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }->
  file {'/etc/dovecot/private':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }->
  file {'/etc/dovecot/dovecot.pem':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "${ssl_base}/ssl/certs/mail.crt",
  }->
  file {'/etc/dovecot/private/dovecot.pem':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => "${ssl_base}/ssl/certs/mail.key",
  }
}
