import Config

config :kaibosh,
  ecto_repos: [Kaibosh.Repo],
  version: System.cmd("git", ["rev-parse", "--short", "HEAD"]) |> elem(0) |> String.trim()

config :kaibosh, Kaibosh.Repo, migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :kaibosh, KaiboshWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: KaiboshWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kaibosh.PubSub,
  live_view: [signing_salt: "Zy2jnxp8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kaibosh, Kaibosh.Mailer,
  adapter: Bamboo.MailgunAdapter,
  hackney_opts: [recv_timeout: :timer.minutes(1)]

import_config "#{config_env()}.exs"
