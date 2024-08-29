import Config

config :kaibosh, KaiboshWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  url: [host: System.fetch_env!("DOMAIN"), port: 443, scheme: "https"]

config :kaibosh, Kaibosh.Repo,
  username: System.fetch_env!("DB_USERNAME"),
  password: System.fetch_env!("DB_PASSWORD"),
  database: System.fetch_env!("DB_NAME"),
  hostname: System.fetch_env!("DB_HOST"),
  port: System.fetch_env!("DB_PORT"),
  ssl: true,
  ssl_opts: [cacertfile: to_charlist(System.fetch_env!("DB_PORT"))],
  start_apps_before_migration: [:ssl]

if config_env() == :prod do
  config :sentry,
    dsn: System.fetch_env!("SENTRY_DSN"),
    enable_source_code_context: true,
    root_source_code_path: File.cwd!()
end

config :kaibosh, Kaibosh.Mailer,
  domain: "mg.#{System.fetch_env!("DOMAIN")}",
  api_key: System.fetch_env!("MAILGUN_API_KEY")
