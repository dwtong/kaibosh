defmodule KaiboshWeb.Email do
  use Bamboo.Phoenix, view: KaiboshWeb.EmailView
  alias Kaibosh.Mailer

  def reset_password_email(%{email: email, password_reset_token: token}) do
    url = "#{KaiboshWeb.Endpoint.url()}/reset_password?password_reset_token=#{token}"

    base_email()
    |> to(email)
    |> assign(:email, email)
    |> assign(:url, url)
    |> render(:password_reset)
    |> Mailer.deliver_later()
  end

  def base_email do
    new_email()
    |> from("Kaibosh Platform<noreply@kaibosh.org.nz>")
    |> put_header("Reply-to", "dev@kaibosh.org.nz")
  end
end
