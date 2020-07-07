defmodule Kaibosh.Accounts.UserTest do
  use Kaibosh.DataCase
  alias Kaibosh.Accounts.User

  @valid_attrs %{email: "test@test.com", password: "pa55word"}

  describe "setting and checking password" do
    test "password must be at least eight characters long" do
      changeset = User.changeset(%User{}, %{password: "passwor"})
      assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)
    end

    test "password hash is generated when password is set" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert %{password_hash: hash} = changeset.changes
      assert !is_nil(hash)
    end

    test "password is valid if it matches hash" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert %{password_hash: hash} = changeset.changes
      assert {:ok, _user} = User.check_password(%User{password_hash: hash}, @valid_attrs.password)
    end

    test "password is not valid if it does not match hash" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert %{password_hash: hash} = changeset.changes

      assert {:error, "invalid password"} =
               User.check_password(%User{password_hash: hash}, "invalid password")
    end
  end
end
