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
    recipient_params = build_params(recipient_params)

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

  defp build_params(%{"has_signed_terms" => has_signed_terms} = params) do
    params
    |> Map.put("signed_terms_at", bool_to_timestamp(has_signed_terms))
    |> Map.delete("has_signed_terms")
    |> build_params()
  end

  defp build_params(%{"has_met_kaibosh" => has_met_kaibosh} = params) do
    params
    |> Map.put("met_kaibosh_at", bool_to_timestamp(has_met_kaibosh))
    |> Map.delete("has_met_kaibosh")
    |> build_params()
  end

  defp build_params(params), do: params

  defp bool_to_timestamp(true), do: DateTime.utc_now()
  defp bool_to_timestamp(false), do: nil
end
