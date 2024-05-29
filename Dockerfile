FROM ubuntu:24.04

ENV REFRESHED_AT=2020-04-29

# Install prerequisites.

RUN apt-get update \
  && apt-get -y install \
  mysql-client \
  && rm -rf /var/lib/apt/lists/*

# Copy the repository's app directory.

COPY ./app /app

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Make non-root container.

USER 1001

ENTRYPOINT ["/app/docker-entrypoint.sh"]
