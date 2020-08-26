import Config

config :kaibosh, KaiboshWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  url: [host: System.fetch_env!("DOMAIN"), port: 443, scheme: "https"]

config :kaibosh, Kaibosh.Repo,
  username: System.fetch_env!("DB_USERNAME"),
  password: System.fetch_env!("DB_PASSWORD"),
  database: System.fetch_env!("DB_NAME"),
  hostname: System.fetch_env!("DB_HOST"),
  port: System.fetch_env!("DB_PORT")

config :sentry,
  dsn: System.fetch_env!("SENTRY_DSN"),
  environment_name: System.fetch_env!("APP_ENV")

config :kaibosh, Kaibosh.Mailer, api_key: System.fetch_env!("SENDGRID_API_KEY")
