defmodule KaiboshWeb.UserSessionControllerTest do
  use KaiboshWeb.ConnCase
  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.UserSession

  setup %{conn: conn} do
    {:ok, user} = Accounts.create_user(%{email: "test@test.com", password: "pa55word"})
    {:ok, user: user, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign in user" do
    test "creates user session and sets headers/cookies", %{user: user, conn: conn} do
      conn = post(conn, "/api/sign_in", %{"email" => user.email, "password" => user.password})

      assert json_response(conn, 201)
      assert Repo.get_by(UserSession, user_id: user.id)
      assert %{cookies: %{"_kaibosh_token" => _}} = fetch_cookies(conn)
      assert ["Bearer " <> _] = get_resp_header(conn, "authorization")
    end

    test "returns not found for missing user", %{conn: conn} do
      conn = post(conn, "/api/sign_in", %{"email" => "foo@bar.com", "password" => "password"})

      assert json_response(conn, 404)
    end
  end

  describe "sign out user" do
    test "destroys user session deletes cookies", %{user: user, conn: conn} do
      conn = post(conn, "/api/sign_in", %{"email" => user.email, "password" => user.password})

      assert Repo.get_by(UserSession, user_id: user.id)

      conn = delete(conn, "/api/sign_out")

      assert response(conn, 204)
      assert fetch_cookies(conn).cookies == %{}
      refute Repo.get_by(UserSession, user_id: user.id)
    end
  end
end
