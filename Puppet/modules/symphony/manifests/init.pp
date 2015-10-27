###
class symphony {
    class { 'nginx': }
    include ::php
    exec { "downloading symphony":
        command => 'mkdir -p /var/www/ && wget --output-document /var/www/symphony.zip http://symfony.com/download?v=Symfony_Standard_Vendors_2.3.3.tgz && unzip -d /var/www /var/www/symphony.zip && mv /var/www/symphony-* /var/www/symphony &&  /var/www/symphony.zip',
        path => '/bin:/usr/bin:/usr/local/bin',
        onlyif => 'test ! -d /var/www/symphony'
    }
}
