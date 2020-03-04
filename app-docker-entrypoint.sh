#!/usr/bin/env bash
set -e

if [ "$1" = 'apache2-foreground' ]; then

  until bin/console doctrine:database:create --quiet --no-interaction --if-not-exists; do
    >&2 echo "Database is unavailable - sleep for 10s"
    sleep 10
  done

  >&2 echo "The database is up - resuming"
  bin/console doctrine:migrations:migrate --no-interaction \
    && vendor/bin/envoi validate \
    && APP_ENV=$APP_ENV apache2-foreground

fi

exec "$@"
