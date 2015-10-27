#####
class pg::pgpool ( 
    $pgpackages,
    ){
    include pg::apt
    package { $pgpackages:
        ensure => 'installed',
        require => Class[Pg::Apt],
    }
}
