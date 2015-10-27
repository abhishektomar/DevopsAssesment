file { "/tmp/abc":
    ensure => present,
    source => "puppet:///modules/mongodb/sample"
}
