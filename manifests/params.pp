class ps_ioncubeloader::params
{
  if $::osfamily == 'Debian' {
    $module_status				= present
    $apache_modules_dir_parent	= '/etc/apache2/modules/'
    $apache_modules_dir			= '/etc/apache2/modules/icl/'
    $apache_php_dir				= '/etc/php5/apache2/conf.d/'
    $php_version				= 'php54'
    $php_priority				= '05'
  }
  elsif $::osfamily == 'Gentoo' {
    $module_status        = present
    $apache_modules_dir_parent  = '/opt/ioncube/'
    $apache_modules_dir     = '/opt/ioncube/'
    $php_version        = 'php5.5'
    $apache_php_dir       = "/etc/php/apache2-${php_version}/ext/"
    $apache_php_dir_active       = "/etc/php/apache2-${php_version}/ext-active/"
    $php_priority       = '05'
  }
  else {
    fail("Unsupported osfamily ${::osfamily}")
  }

  $ioncube_server = 'http://downloads3.ioncube.com/loader_downloads/'

  if $::hardwaremodel == 'x86_64' {
    $package_suffix = '-64'
  } else {
    $package_suffix = ''
  }

  # http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz
  $archive_file = "ioncube_loaders_lin_x86${package_suffix}.tar.gz"
}