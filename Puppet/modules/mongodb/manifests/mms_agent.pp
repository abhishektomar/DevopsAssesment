# This installs a mongo cloud manager automation, monitoring and backup Agents
class mongodb::mms_agent (
    $mms_key    = undef,
    $provider     = 'dpkg',
) {

    file {'/tmp/mongodb-mms-monitoring-agent_3.7.0.212-1_amd64.deb':
        ensure => present,
        source => "puppet:///modules/mongodb/mongodb-mms-monitoring-agent_3.7.0.212-1_amd64.deb",
    }
    file {'/tmp/mongodb-mms-backup-agent_3.7.0.304-1_amd64.deb':
        ensure => present,
        source =>'puppet:///modules/mongodb/mongodb-mms-backup-agent_3.7.0.304-1_amd64.deb',
    }

    package {'backup':
        ensure => present,
        provider => "${provider}",
        source => '/tmp/mongodb-mms-backup-agent_3.7.0.304-1_amd64.deb',
    }
    package {'monitoring':
        ensure => present,
        provider => "${provider}",
        source => '/tmp/mongodb-mms-monitoring-agent_3.7.0.212-1_amd64.deb',
    }

    file {'/etc/mongodb-mms/backup-agent.config':
        ensure => present,
        content => template('mongodb/backup-agent.config.erb'),
        require => Package[backup],
        notify => Service[mmsagent_backup],
    }

    file {'/etc/mongodb-mms/monitoring-agent.config':
        ensure => present,
        content => template('mongodb/monitoring-agent.config.erb'),
        require => Package[monitoring],
        notify => Service[mmsagent_monitoring],
    }
    
    service {'mmsagent_backup':
        name => 'mongodb-mms-backup-agent',
        ensure => running,
        start => 'start mongodb-mms-backup-agent',
        stop => 'stop mongodb-mms-backup-agent',
        require => File['/etc/mongodb-mms/monitoring-agent.config'],
    }

    service {'mmsagent_monitoring':
        name => 'mongodb-mms-monitoring-agent',
        ensure => running,
        start => 'start mongodb-mms-monitoring-agent',
        stop => 'stop mongodb-mms-monitoring-agent',
        require => File['/etc/mongodb-mms/monitoring-agent.config'],
    }
}
