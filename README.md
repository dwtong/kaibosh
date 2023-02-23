# Kaibosh

## Development Environment

There is a development environment available with docker compose. Start it with `docker compose up`.

Alternatively, you can:

  * Install dependencies with `mix deps.get`
  * Populate your environment with any `POSTGRES_*` variables required (see dev.exs)
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
