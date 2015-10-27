class {'::mongodb::globals':
  manage_package_repo => true,
  distro => "trusty/mongodb-org/stable",
  client_package_name => "mongodb-org-shell",
}
