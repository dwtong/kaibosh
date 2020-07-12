defmodule KaiboshWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use KaiboshWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import Kaibosh.DateHelper
      import Kaibosh.Factory
      import KaiboshWeb.ConnCase

      alias KaiboshWeb.Router.Helpers, as: Routes
      alias Kaibosh.Repo

      # The default endpoint for testing
      @endpoint KaiboshWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Kaibosh.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Kaibosh.Repo, {:shared, self()})
    end

    conn =
      Phoenix.ConnTest.build_conn()
      |> Plug.Conn.put_req_header("accept", "application/json")
      |> put_auth_token_header()
      |> put_session_cookie()

    {:ok, conn: conn}
  end

  defp put_auth_token_header(conn) do
    token = KaiboshWeb.Authentication.generate_token(1, 5000)
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
  end

  defp put_session_cookie(conn) do
    token = KaiboshWeb.Authentication.generate_token(1, 500)
    Plug.Test.put_req_cookie(conn, "_kaibosh_token", token)
  end
end
