####
class mongo::client (
  $mongo_packages,
  ) {
  if $mongo_packages {
		$packages = split($mongo_packages, ',')
		
    include "::mongodb::repo"
    package { $packages:
      ensure => present,
      tag => 'mongodb-org',
    }
  }
}
