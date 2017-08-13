defmodule Api.AdminPlug do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    case conn.remote_ip do
      {127, 0, 0, 1} ->
        conn
        |> assign(:admin, true)
      _ ->
        conn
        |> assign(:admin, false)
    end
  end

  def is_admin?(conn, _opts) do
    case conn.assigns.admin do
      true ->
        conn
      false ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(403, "Not an admin!")
        |> halt
    end
  end

end
