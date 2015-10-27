####
class symphony::nginx (
    $packages,
    $server_name,
    $document_root,
){
    anchor { "symphony::nginx::start" : }-> 
    package { $packages: ensure => installed }-> 
    #file {"/etc/nginx/conf.d/default.conf":
    #    ensure => present,
    #    owner => root, 
    #    group => root,
    #    content => template("symphony/symphony.conf.erb")
    #}~> 
    service {"nginx":
        ensure => running,
   #     require => File["/etc/nginx/conf.d/default.conf"],
    }   
    anchor { "symphony::nginx::stop" : } 

}
