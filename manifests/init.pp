class ps_ioncubeloader (

	$apache_modules_dir	= $ps_ioncubeloader::params::apache_modules_dir,
	$apache_php_dir		= $ps_ioncubeloader::params::apache_php_dir,

) inherits ps_ioncubeloader::params {

	file { "${apache_modules_dir}":
		ensure => 'directory',
		mode => 750,
		owner => 'root',
	}
	
	file { "${apache_modules_dir}ioncube_loader_lin_php-5.3-linux-glibc23-x86_64.so":
		ensure => present,
	    source => "puppet:///modules/ps_ioncubeloader/ioncube_loader_lin_php-5.3-linux-glibc23-x86_64.so",
	    subscribe => File["${apache_modules_dir}"]
	}
	
	file { "${apache_php_dir}conf.d/ps_ioncubeloader.ini":
		ensure => present,
	    content => template("ps_ioncubeloader/ps_ioncubeloader.ini.erb"),
	    subscribe => File["${apache_modules_dir}ioncube_loader_lin_php-5.3-linux-glibc23-x86_64.so"]
	}
	
	exec { "apache_restart-icl":
    	command => "/etc/init.d/apache2 reload",
		refreshonly => true,
    	subscribe => File["${apache_php_dir}conf.d/ps_ioncubeloader.ini"],
	}

}