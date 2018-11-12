FROM gliderlabs/alpine:3.6

ENV REFRESHED_AT=2018-11-12

# Install prerequisites.

RUN apk-install mysql-client bash

# Copy the repository's app directory.

COPY ./app /app

ENTRYPOINT ["/app/docker-entrypoint.sh"]