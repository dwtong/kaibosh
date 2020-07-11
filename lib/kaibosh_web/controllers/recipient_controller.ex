defmodule KaiboshWeb.RecipientController do
  use KaiboshWeb, :controller

  alias Kaibosh.Recipients
  alias Kaibosh.Recipients.Recipient

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    recipients = Recipients.list_recipients()
    render(conn, "index.json", recipients: recipients)
  end

  def create(conn, %{"recipient" => recipient_params}) do
    with {:ok, %Recipient{} = recipient} <- Recipients.create_recipient(recipient_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.recipient_path(conn, :show, recipient))
      |> render("show.json", recipient: recipient)
    end
  end

  def show(conn, %{"id" => id}) do
    recipient = Recipients.get_recipient!(id)
    render(conn, "show.json", recipient: recipient)
  end

  def update(conn, %{"id" => id, "recipient" => recipient_params}) do
    recipient = Recipients.get_recipient!(id)

    with {:ok, %Recipient{} = recipient} <-
           Recipients.update_recipient(recipient, recipient_params) do
      render(conn, "show.json", recipient: recipient)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipient = Recipients.get_recipient!(id)

    with {:ok, %Recipient{}} <- Recipients.archive_recipient(recipient) do
      send_resp(conn, :no_content, "")
    end
  end
end
