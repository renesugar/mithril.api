defmodule Mithril.Web.ClientController do
  use Mithril.Web, :controller

  alias Mithril.ClientAPI
  alias Mithril.ClientAPI.Client
  alias Scrivener.Page

  action_fallback(Mithril.Web.FallbackController)

  def index(conn, params) do
    with %Page{} = paging <- ClientAPI.list_clients(params) do
      render(conn, "index.json", clients: paging.entries, paging: paging)
    end
  end

  def create(conn, %{"client" => client_params}) do
    with {:ok, %Client{} = client} <- ClientAPI.create_client(client_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", client_path(conn, :show, client))
      |> render("show.json", client: client)
    end
  end

  def show(conn, %{"id" => id}) do
    client = ClientAPI.get_client_with_type!(id)
    render(conn, "client.json", client: client, client_type_name: client.client_type.name)
  end

  def details(conn, %{"client_id" => id}) do
    client = ClientAPI.get_client_with_type!(id)
    render(conn, "details.json", client: client, client_type_name: client.client_type.name)
  end

  def update(conn, %{"id" => id, "client" => client_params}) do
    with {:ok, %Client{} = client} <- ClientAPI.edit_client(id, client_params) do
      render(conn, "show.json", client: client)
    end
  end

  def delete(conn, %{"id" => id}) do
    client = ClientAPI.get_client!(id)

    with {:ok, %Client{}} <- ClientAPI.delete_client(client) do
      send_resp(conn, :no_content, "")
    end
  end

  def refresh_secret(conn, %{"client_id" => id}) do
    client = ClientAPI.get_client!(id)

    with {:ok, %Client{} = client} <- ClientAPI.refresh_secret(client) do
      render(conn, "show.json", client: client)
    end
  end
end
