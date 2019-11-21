# docker-mysql-init

## Overview

This Dockerfile is a wrapper over the [MySQL Command-Line Tool](https://dev.mysql.com/doc/refman/8.0/en/mysql.html).

This Dockerfile is similar to
[senzing/mysql](https://github.com/Senzing/docker-mysql),
but differs in the following ways:

1. The command is only run once.
   A "Sentinel File" is created on the first run.
   It prevents future runs.
   The file should be located on an external volume.
   Default location: `/opt/senzing/mysql-init.sentinel`.
1. On the first run, the command loops until it succeeds.
   This is useful in docker-compose formations where the `mysql` command needs to wait for mysql server to come up.
   An example is at
   [senzing/docker-compose-mysql-demo](https://github.com/Senzing/docker-compose-mysql-demo).

### Contents

1. [Create Docker container](#create-docker-container)
1. [Docker network](#docker-network)
1. [Run Docker container](#run-docker-container)

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps you'll need to make some choices.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Create docker container

1. Build docker container.
   Example:

    ```console
    sudo docker build \
      --tag senzing/mysql-init \
      https://github.com/senzing/docker-mysql-init.git
    ```

## Docker network

:thinking: **Optional:**  Use if docker container is part of a docker network.

1. List docker networks.
   Example:

    ```console
    sudo docker network ls
    ```

1. :pencil2: Specify docker network.
   Choose value from NAME column of `docker network ls`.
   Example:

    ```console
    export SENZING_NETWORK=*nameofthe_network*
    ```

1. Construct parameter for `docker run`.
   Example:

    ```console
    export SENZING_NETWORK_PARAMETER="--net ${SENZING_NETWORK}"
    ```

## Run Docker container

1. :pencil2: Identify the file of SQL to be run.
   Example:  If the actual file pathname is `/path/to/mysqlfile.sql`

    ```console
    export MYSQL_DIR=/path/to
    export MYSQL_FILE=mysqlfile.sql
    ```

1. :pencil2: Identify the database username and password.
   Example:

    ```console
    export MYSQL_USERNAME=root
    export MYSQL_PASSWORD=root
    ```

1. :pencil2: Identify the database that is the target of the SQL statements.
   Example:

    ```console
    export MYSQL_DATABASE=mydatabase
    ```

1. :pencil2: Identify the host running mySQL servers.
   Example:

    ```console
    sudo docker ps

    # Choose value from NAMES column of docker ps
    export MYSQL_HOST=docker-container-name
    ```

1. :pencil2: Identify where the "sentinel file" should be located.
   The file should be on an external volume.
   Example:

    ```console
    export SENZING_SENTINEL_FILE="${MYSQL_DIR}/mysql-init.sentinel"
    ```

1. Create the docker container.
   Note: parameters after senzing/mysql-init are
   [mysql CLI options](https://dev.mysql.com/doc/refman/5.7/en/mysql-command-options.html).

    ```console
    sudo docker run -it  \
      --volume ${MYSQL_DIR}:/sql \
      --env SENZING_SENTINEL_FILE=${SENZING_SENTINEL_FILE} \
      ${SENZING_NETWORK_PARAMETER} \
      senzing/mysql-init \
        --user=${MYSQL_USERNAME} \
        --password=${MYSQL_PASSWORD} \
        --host=${MYSQL_HOST} \
        --database=${MYSQL_DATABASE} \
        --execute="source /sql/${MYSQL_FILE}"
    ```
