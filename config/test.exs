use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :kaibosh, Kaibosh.Repo,
  username: "postgres",
  password: "postgres",
  database: "kaibosh_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :kaibosh, Kaibosh.Mailer, adapter: Bamboo.TestAdapter

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kaibosh, KaiboshWeb.Endpoint,
  http: [port: 4002],
  server: false

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

# Print only warnings and errors during test
config :logger, level: :warn
