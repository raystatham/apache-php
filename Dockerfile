FROM debian:bullseye
MAINTAINER Ray Statham Docker@Rapidphp.com

# Usage:
# docker run -d --name=apache-php -p 8080:80 -p 8443:443 raystatham/apache-php
# webroot: /var/www/html/
# Apache2 config: /etc/apache2/

RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get -y install \
        wget \
        apache2 \
        libapache2-mod-php \
        php \
        php-common \
        php-mysql && \
        apt-get clean && rm -r /var/lib/apt/lists/*

# Apache + PHP requires preforking Apache for best results & enable Apache SSL
# forward request and error logs to docker log collector

RUN a2dismod mpm_event && \
    a2enmod mpm_prefork \
        ssl \
        rewrite \
        proxy \
        proxy_http && \
    a2ensite default-ssl && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

# Install Certbot for Apache2
#RUN wget https://dl.eff.org/certbot-auto
#RUN mv certbot-auto /usr/local/bin/certbot-auto
#RUN chown root /usr/local/bin/certbot-auto
#RUN chmod 0755 /usr/local/bin/certbot-auto
#RUN echo "0 0,1 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew" | tee -a /etc/crontab > /dev/null

WORKDIR /var/www/html

COPY apache2-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/apache2-foreground

EXPOSE 80
EXPOSE 443

CMD ["apache2-foreground"]
