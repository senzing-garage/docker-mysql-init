FROM ubuntu

ENV REFRESHED_AT=2020-04-29

# Install prerequisites.

RUN apt-get update \
 && apt-get -y install \
      mysql-client \
 && rm -rf /var/lib/apt/lists/*

# Copy the repository's app directory.

COPY ./app /app

ENTRYPOINT ["/app/docker-entrypoint.sh"]
