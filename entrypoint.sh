#!/bin/bash
set -e

cp /$LOCK_PATH/* /$APP_PATH/

# run passed commands
exec "$@"
