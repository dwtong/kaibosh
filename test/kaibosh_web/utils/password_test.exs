defmodule KaiboshWeb.PasswordTest do
  use KaiboshWeb.ConnCase
  alias Kaibosh.Accounts.User
  alias KaiboshWeb.Password

  describe "generating new password reset token" do
    setup [:create_user]

    test "generates password token and updates user", %{user: %{email: user_email}} do
      assert {:ok, %User{} = user} = Password.generate_token(user_email)
      refute is_nil(user.password_reset_token)
    end

    test "does not generate token if user does not exist" do
      assert {:error, :invalid_user} = Password.generate_token("foo@bar.com")
    end
  end

  describe "validating password reset token" do
    setup [:create_user]

    test "validates token and removes valid token from user", %{user: %{email: user_email}} do
      assert {:ok, %User{password_reset_token: token}} = Password.generate_token(user_email)
      assert {:ok, %User{id: user_id}} = Password.validate_token(token)

      user = Repo.get(User, user_id)
      assert is_nil(user.password_reset_token)
    end

    test "returns error for invalid token" do
      assert {:error, :invalid_token} = Password.validate_token("xxx")
    end
  end

  defp create_user(_) do
    %{user: insert(:user, email: "test@test.com")}
  end
end
