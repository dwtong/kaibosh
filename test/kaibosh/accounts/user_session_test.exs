defmodule Kaibosh.Accounts.UserSessionTest do
  use Kaibosh.DataCase
  alias Kaibosh.Accounts.UserSession

  @valid_attrs %{
    user_id: "8752c2d3-54c2-4b61-bdb3-4f7f139a1cec"
  }

  describe "generating session token" do
    test "generates token when there is none set" do
      changeset = UserSession.changeset(%UserSession{}, @valid_attrs)
      assert %{token: token} = changeset.changes
      assert !is_nil(token)
    end

    test "does not generate token when there is one set" do
      changeset =
        UserSession.changeset(
          %UserSession{token: "8752c2d3-54c2-4b61-bdb3-4f7f139a1cec"},
          @valid_attrs
        )

      assert %{} = changeset.changes
    end
  end
end
