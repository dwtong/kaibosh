defmodule Kaibosh.Repo do
  use Ecto.Repo,
    otp_app: :kaibosh,
    adapter: Ecto.Adapters.Postgres
end
