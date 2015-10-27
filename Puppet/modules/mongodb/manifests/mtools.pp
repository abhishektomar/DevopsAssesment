# Below code will install the mtools package for mongodb.
# To know more about mtools : https://github.com/rueckstiess/mtools

class mongodb::mtools {
    $packages=["python-pip","python-dev"]
    package {$packages: ensure => "installed",}
    package {'mtools':
        ensure => 'installed',
        provider => 'pip',
    }   
} 
