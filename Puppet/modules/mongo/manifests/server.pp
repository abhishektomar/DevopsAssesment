###
class mongo::server (
    $package_name,
	$dbpath,
	$storage_engine,
	$port,
	) {
        anchor { 'mongo::server::start': }->
		class {'::mongodb::globals':
			manage_package_repo => true,
		}->
		class {'::mongodb::server':
			package_name => $package_name,
			port    => $port,
			bind_ip => "${::ipaddress}",
			storage_engine => "$storage_engine",
			dbpath => "$dbpath",
			verbose => true,
		}->
		class {'::mongodb::mms_agent':
			mms_key => "$mms_key",
		}->
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
        anchor { 'mongo::server::end': }
}
