#!/usr/bin/env bash
# Run a one-time mysql command until it succeeds.

# A file used to determine if/when this program has previously run.

SENTINEL_FILE=${SENZING_SENTINEL_FILE:-/opt/senzing/mysql-init.sentinel}

# Parameters from docker command.

MYSQL_PARAMETERS="$@"

if [ ! -f ${SENTINEL_FILE} ]; then

  # Append to a "Sentinel file" to indicate when this script has been run.
  # The Sentinel file is used to identify the first run from subsequent runs for "first-time" processing.

  echo "$(date)" >> ${SENTINEL_FILE}

  # Run mysql with the parameters.

  COMMAND="mysql ${MYSQL_PARAMETERS}"
  echo "Executing: ${COMMAND}"
  while ! $(/bin/bash -c "${COMMAND}") ; do
    echo "Sleeping 15 seconds, then will re-try."
    sleep 15
  done

fi
