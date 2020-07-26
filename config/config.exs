# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kaibosh,
  ecto_repos: [Kaibosh.Repo]

config :kaibosh, Kaibosh.Repo, migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :kaibosh, KaiboshWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FWitQedZ/iDC4wZgZSqn6j6MUYuEOZa8hlHYxD2PjZXB6la7b+N9lLZUQSkgYczO",
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
  adapter: Bamboo.SendGridAdapter,
  api_key: "my_api_key",
  hackney_opts: [recv_timeout: :timer.minutes(1)]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
