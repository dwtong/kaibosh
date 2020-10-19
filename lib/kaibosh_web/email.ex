defmodule KaiboshWeb.Email do
  @moduledoc """
  Manages building emails from within the KaiboshWeb application.
  Uses templates in emails subdirectory.
  """
  use Bamboo.Phoenix, view: KaiboshWeb.EmailView
  alias Kaibosh.Mailer
  alias Kaibosh.Recipients.Recipient

  def reset_password_email(%{email: email, password_reset_token: token}) do
    url = "#{KaiboshWeb.Endpoint.url()}/reset_password?password_reset_token=#{token}"

    base_email()
    |> to(email)
    |> subject("Password reset link")
    |> assign(:email, email)
    |> assign(:url, url)
    |> render(:password_reset)
    |> Mailer.deliver_later()
  end

  def new_signup_email(emails, %Recipient{id: id, name: recipient_name, base: %{name: base_name}})
      when is_list(emails) do
    url = "#{KaiboshWeb.Endpoint.url()}/recipients/#{id}"

    base_email()
    |> to(emails)
    |> subject("New recipient sign up")
    |> assign(:recipient, recipient_name)
    |> assign(:base, base_name)
    |> assign(:url, url)
    |> render(:new_signup)
    |> Mailer.deliver_later()
  end

  def base_email do
    new_email()
    |> from("Kaibosh Platform<noreply@kaibosh.org.nz>")
    |> put_header("reply-to", "dev@kaibosh.org.nz")
  end
end
