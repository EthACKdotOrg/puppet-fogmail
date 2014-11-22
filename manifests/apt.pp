class fogmail::apt {


  # initialize apt
  class {'::apt':
    purge_sources_list   => true,
    purge_sources_list_d => true,
    purge_preferences_d  => true,
  }

  ::apt::conf {'ignore-recommends':
    content => '
  APT::Install-Recommends "0";
  APT::Install-Suggests "0";
  ',
  }
  class {'::apt::unattended_upgrades':
    origins =>  [
      'o=Debian,n=jessie',
      'o=Debian,n=jessie-updates',
      'o=Debian,n=jessie-proposed-updates',
      'o=Debian,n=jessie,l=Debian-Security',
    ],
  }

  # install common source lists
  ::apt::source {$::lsbdistcodename:
    location => 'http://http.debian.net/debian',
    release  => $::lsbdistcodename,
    repos    => 'main contrib non-free',
  }

  ::apt::source {"${::lsbdistcodename}-updates":
    location => 'http://http.debian.net/debian',
    release  => "${::lsbdistcodename}-updates",
    repos    => 'main contrib non-free',
  }

  ::apt::source {"${::lsbdistcodename}-security":
    location => 'http://security.debian.org',
    release  => "${::lsbdistcodename}/updates",
    repos    => 'main contrib non-free',
  }

  $repo = 'http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.10/'
  ::apt::source {'xtreemfs':
    location   => $repo,
    repos      => './',
    release    => '',
    key        => '07D6EA4F2FA7E736',
    key_source => "${repo}/Release.key",
  }
}
