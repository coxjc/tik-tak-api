defmodule Api.AuthTokenPlug do
  import Plug.Conn

  alias Api.User
  alias Api.AuthToken

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    case get_req_header(conn, "auth-token") do
      [auth_token_string | _tail] -> 
        auth_token = auth_token_string && repo.get_by(AuthToken, token:  auth_token_string)
      _ ->
        auth_token = nil
    end
    case auth_token do
      nil -> 
        user = nil
      _ ->
        user = repo.get_by(User, id: auth_token.user_id)
    end
    conn 
    |> assign(:auth_token, auth_token)
    |> assign(:user, user)
  end

  def authenticate_auth_token(conn, _opts) do
    if AuthToken.valid?(conn.assigns.auth_token) do 
       conn
    else 
      conn 
      |> put_resp_content_type("text/plain") 
      |> send_resp(403, "No valid 'auth-token' header present!")
      |> halt
    end
  end

end
