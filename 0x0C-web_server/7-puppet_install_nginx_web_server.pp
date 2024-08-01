# Update system
exec { 'update_system':
  command => '/usr/bin/apt-get update',
}

# Install Nginx package
package { 'nginx':
  ensure  => 'installed',
  require => Exec['update_system'],
}

# Create Hello World index.html file
file { '/var/www/html/index.html':
  ensure  => 'file',
  content => 'Hello World!',
}

# Configure redirection in Nginx default site configuration
file { '/etc/nginx/sites-available/default':
  ensure  => 'file',
  content => template('nginx/default.conf.erb'),  # Use a template for better management
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Service management for Nginx
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Package['nginx'],
}
