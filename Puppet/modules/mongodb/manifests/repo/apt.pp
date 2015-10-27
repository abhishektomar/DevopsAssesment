# PRIVATE CLASS: do not use directly
class mongodb::repo::apt inherits mongodb::repo {
  # we try to follow/reproduce the instruction
  # from http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/

  include ::apt
## Added by abhishek
  if($::mongodb::repo::ensure == 'present' or $::mongodb::repo::ensure == true) {
    apt::source { 'mongodb-org':
      location    => $::mongodb::repo::location,
      release     => "$lsbdistcodename/mongodb-org/stable",
      repos       => 'multiverse',
      key         => '7F0CEB10',
      key_server  => 'keyserver.ubuntu.com',
      include_src => false
    }
########
#  if($::mongodb::repo::ensure == 'present' or $::mongodb::repo::ensure == true) {
#    apt::source { 'downloads-distro.mongodb.org'
#      location => $::mongodb::repo::location,
#      release     => 'dist',
#      repos       => '10gen',
#      key         => '492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10',
#      key_server  => 'hkp://keyserver.ubuntu.com:80',
#      include_src => false,
#    }

    Apt::Source['mongodb-org']->Package<|tag=='mongodb-org'|>
  }
  else {
    apt::source {'mongodb-org':
      ensure => absent,
    }
  }
}
