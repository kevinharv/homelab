FROM httpd:2.4-bookworm

RUN apt-get update && apt-get install apache2-utils
RUN mkdir -p /var/lib/dav && chown -R www-data:www-data /var/lib/dav && chmod 700 /var/lib/dav


COPY demo-site/* /usr/local/apache2/htdocs/
COPY entrypoint.sh .
RUN chmod 700 entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]