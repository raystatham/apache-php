# Apache, CertBot, PHP with Proxy enabled for Docker

This project was cloned from [chriswayg/apache-php](https://github.com/chriswayg/apache-php) to give me a baseline build before enabling the Proxy_Pass module and installing Certbot. Please view the original project for full instructions.

Docker image with Apache2 web server and PHP based on the official Debian Bullseye image:

- Apache 2.4.53 web server
- HTTPS/SSL enabled
- Proxy_Pass enabled
- PHP 7.4
- Logging enabled
- Certbot installed for creating valid SSL certificates
- All original Debian Packages (not compiled from source)

## Docker Build

Create a new local Docker container:
```
docker build . -t raystatham/apache-php
```

## Example create.sh Script
```
#!/bin/bash

docker create --restart=unless-stopped \
      --name ApachePHP \
      -p 80:80 \
      -p 443:443 \
      -v "$PWD/sites-available":/etc/apache2/sites-available \
      -v "$PWD/html":/var/www/html \
      -v "$PWD/certificates":/etc/letsencrypt \
      raystatham/apache-php:latest
```
## Generate Certificates
Generate the certificates for all VHOSTs defined within the local mapped foler `sites-available`. A cron job within the container will then renew each of your certificates if required at midnight on the first day of each month. See Certbot documentation for further information on the link below.
```
$ docker exec -it ApachePHP /bin/bash
$ /usr/local/bin/certbot-auto --apache
```
## External References

- [https://certbot.eff.org/](https://certbot.eff.org/)

## Updated

* 22/12/2020
