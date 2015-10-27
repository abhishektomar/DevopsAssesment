###
class pg::server (
   $pgpackages,
    ) {
    include pg::apt
    anchor { 'pg::server::start': }->
    package { $pgpackages:
        ensure => 'installed',
        require => Class[Pg::Apt],
    }->
    file { "ph_hba_conf":
        path => "/etc/postgresql/9.2/main/pg_hba.conf",
        ensure => "present",
        source => "puppet:///modules/pg/pg_hba.conf",
        owner => "postgres",
        group => "postgres",
        mode => 0640,
    }
    file { "postgresql_conf":
        path => "/etc/postgresql/9.2/main/postgresql.conf",
        ensure => "present",
        source => "puppet:///modules/pg/postgresql.conf",
        owner => "postgres",
        group => "postgres",
        mode => 0644,
    }~>
    service { "postgresql":
        ensure => "running"
    }
    anchor { 'pg::server::end': }
    File {
        ensure => "present",
        owner  => "postgres",
        group  => "postgres",
        mode   => 644,

    } 
    file {"/etc/postgresql/pgpool-recovery.sql":
        source => "puppet:///modules/pg/pgpool-recovery.sql.in",
        mode   => 660,
        require => Service["postgresql"]
    }
    file {"/etc/postgresql/pgpool-regclass.sql":
        source => "puppet:///modules/pg/pgpool-regclass.sql.in",
        mode   => 660,
        require => Service["postgresql"]
    }
    file {"/etc/postgresql/pgpool-walrecrunning.sql":
        source => "puppet:///modules/pg/pgpool-walrecrunning.sql.in",
        mode   => 660,
        require => Service["postgresql"]
    }

}
