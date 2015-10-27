## Below script will install the latest version of MongoDB, with replica set 'puppet-testing'.
class mongo::primary {
    class {'::mongodb::globals':
        manage_package_repo => true,
        distro => "trusty/mongodb-org/stable",
    }-> 
    class {'::mongodb::server':
        package_name => 'mongodb-org',
        port    => 27017,
        bind_ip => '0.0.0.0',
        storage_engine => wiredTiger,
        verbose => true,
        oplog_size => 20000,
        replset => 'puppet-testing'
    }-> 
  
  # This is bit tricky, because we have to run this on only one server.
    mongodb_replset { 'puppet-testing':
        ensure  => present,
        members => ['172.28.128.11:27017', '172.28.128.12:27017', '172.28.128.13:27017']
    }   

    class {'::mongodb::mms_agent':
        mms_key => 'sadfasdf34343sadf2Oasf',
    }   

    logrotate::rule {'mongodb':
        path => '/var/log/mongodb/*.log',
        rotate => 30, 
        compress => true,
        dateext => true,
        missingok => true,
        sharedscripts => true,
        copytruncate => true,
        postrotate => '/bin/kill -SIGUSR1 \`cat /var/lib/mongodb/mongod.lock 2> /dev/null\` 2> /dev/null || true'
    }   
}
