# Kaibosh Platform

## Overview

Kaibosh Platform is a web application built for [Kaibosh Food Rescue](https://kaibosh.org.nz), to manage the allocation and distribution of donated food.

The core of the web application is a REST API built using Phoenix/Elixir, with a web based VueJS front-end.

## Development Environment

There is a development environment available with docker compose. Start it with `docker compose up`.

You will need a dev.secret.exs file. Start with the example:
```sh
cp config/dev.secret.exs.example config/dev.secret.exs
```

If mix dependencies need installing, run:
```sh
docker compose run web mix deps.get`
```

Alternatively, you can:

  * Install dependencies with `mix deps.get`
  * Populate your environment with any `POSTGRES_*` variables required (see dev.exs)
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install --prefix client`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Sending Emails in Development

Any emails sent in development can be viewed at [`http://localhost:4000/sent_emails`](http://localhost:4000/sent_emails)
