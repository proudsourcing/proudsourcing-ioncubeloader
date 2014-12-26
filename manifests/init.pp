class ps_ioncubeloader (

	$module_status				= $ps_ioncubeloader::params::module_status,
	$apache_modules_dir_parent	= $ps_ioncubeloader::params::apache_modules_dir_parent,
	$apache_modules_dir			= $ps_ioncubeloader::params::apache_modules_dir,
	$apache_php_dir				= $ps_ioncubeloader::params::apache_php_dir,
	$apache_php_dir_active 	= $ps_ioncubeloader::params::apache_php_dir_active,
	$php_version				= $ps_ioncubeloader::params::php_version,
	$php_priority				= $ps_ioncubeloader::params::php_priority,

) inherits ps_ioncubeloader::params {

	Exec {
    path => ['/bin', '/usr/bin']
  }

	file { "${apache_modules_dir}":
		ensure => 'directory',
		mode => 750,
		owner => 'root',
	}
	
	file { "${apache_php_dir}${php_priority}-ps_ioncubeloader.ini":
		ensure => $module_status,
    content => template("ps_ioncubeloader/ps_ioncubeloader.ini.erb"),
	}

	if $::osfamily == 'Gentoo' {
		file { "${apache_php_dir_active}/${php_priority}-ps_ioncubeloader.ini":
			ensure => 'link',
	    target => "${apache_php_dir}${php_priority}-ps_ioncubeloader.ini"
		}
	}

	exec { 'retrieve_ioncubeloader':
      cwd     => '/tmp',
      command => "wget ${$ioncube_server}${archive_file} && tar xzf ${archive_file} && mv ioncube/* ${apache_modules_dir} && touch ${apache_modules_dir}/ioncube/.installed",
      creates => "${apache_modules_dir}/.installed"
  }
	
	exec { "apache_restart-icl":
  	command => "/etc/init.d/apache2 reload",
		refreshonly => true,
  	subscribe => File["${apache_php_dir}${php_priority}-ps_ioncubeloader.ini"],
	}

}
