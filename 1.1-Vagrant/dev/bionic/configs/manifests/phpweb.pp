exec { 'apt-get update':
 command => '/usr/bin/apt-get update'
}

package { ['php7.2', 'php7.2-mysql']:
 ensure  => "installed",
 require => Exec['apt-get update']
}

exec { 'run-php7':
 require => Package['php7.2'],
 command => '/usr/bin/php -S 0.0.0.0:8888 -t /vagrant/src &'
}
