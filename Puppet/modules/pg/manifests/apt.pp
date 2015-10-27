###
class pg::apt {
    anchor { 'pg::apt::start': }->
    file { "pg_source":
        path => '/etc/apt/sources.list.d/pgdg.list',
        ensure  => "present",
        content => 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main',
        mode => 0644,
    }->
    exec { "Adding_key_and_running_apt_get_update":
        path => '/usr/local/bin:/usr/bin:/bin',
        command => 'wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - && /usr/bin/apt-get update',
        onlyif => 'test -f /etc/apt/sources.list.d/pgdg.list'
    }
    anchor { 'pg::apt::end': }
    
}
