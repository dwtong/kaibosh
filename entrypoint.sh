#!/bin/bash
# Docker entrypoint script.

# if [ -n "${POSTGRES_USER+set}" ]; then
#   echo "env variables not set"
#   exit 1
# fi

# Wait until Postgres is ready
echo "Testing if Postgres is accepting connections. $POSTGRES_HOST $POSTGRES_PORT $POSTGRES_USER"
while ! pg_isready -q -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $POSTGRES_DATABASE"` ]]; then
  echo "Database $POSTGRES_DATABASE does not exist. Creating..."
  mix ecto.create
  mix ecto.migrate
  mix run priv/repo/seeds.exs
  echo "Database $POSTGRES_DATABASE created."
fi

npm install --prefix assets

exec mix phx.server
