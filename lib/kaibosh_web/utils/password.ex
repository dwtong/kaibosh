defmodule KaiboshWeb.Password do
  @moduledoc """
  A collection of functions for checking and generating password tokens.
  """

  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.User
  alias KaiboshWeb.Endpoint

  @salt "password token"
  @one_day 86_400

  def generate_token(email, max_age \\ @one_day) when is_binary(email) do
    with token <- Phoenix.Token.sign(Endpoint, @salt, email, max_age: max_age),
         %User{} = user <- Accounts.get_user_by_email(email),
         {:ok, %User{} = user} <- Accounts.update_user(user, %{password_reset_token: token}) do
      {:ok, user}
    else
      _err ->
        {:error, :invalid_user}
    end
  end

  def validate_token(token) when is_binary(token) do
    with {:ok, email} <- Phoenix.Token.verify(Endpoint, @salt, token),
         %User{password_reset_token: ^token} = user <- Accounts.get_user_by_email(email),
         {:ok, %User{}} <- Accounts.update_user(user, %{password_reset_token: nil}) do
      {:ok, user}
    else
      _err ->
        {:error, :invalid_token}
    end
  end
end
