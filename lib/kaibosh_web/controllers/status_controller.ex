defmodule KaiboshWeb.StatusController do
  use KaiboshWeb, :controller

  def show(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{version: Application.get_env(:app, :version)})
  end
end
