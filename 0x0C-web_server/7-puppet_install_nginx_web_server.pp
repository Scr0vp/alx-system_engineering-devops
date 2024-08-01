# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure    => running,
  enable    => true,
  subscribe => Package['nginx'],
}

# Configure the Nginx server block
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => '
server {
    listen 80;
    
    # Root configuration
    root /var/www/html;
    index index.html;

    # Location for the root URL
    location / {
        try_files $uri $uri/ =404;
        add_header Content-Type text/html;
        return 200 "Hello World!";
    }

    # Redirect configuration
    location /redirect_me {
        return 301 http://$host/new_location;
    }
}
',
  notify  => Service['nginx'],
}

# Ensure the default Nginx configuration is enabled
file { '/etc/nginx/sites-enabled/default':
  ensure  => link,
  target  => '/etc/nginx/sites-available/default',
  notify  => Service['nginx'],
}

# Create the directory and file to serve as the root
file { '/var/www/html/index.html':
  ensure  => file,
  content => 'Hello World!',
  notify  => Service['nginx'],
}
