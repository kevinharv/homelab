# Dockerfile for enterprise Apache web server deployment

FROM httpd:2.4-bookworm

RUN apt update && apt install apache2-utils
RUN mkdir -p /var/lib/dav && chown -R www-data:www-data /var/lib/dav && chmod 700 /var/lib/dav
# ^ convert to volume

COPY demo-site/* /usr/local/apache2/htdocs/
COPY entrypoint.sh .
RUN chmod 700 entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]