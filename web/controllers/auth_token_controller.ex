defmodule Api.AuthTokenController do
  use Api.Web, :controller

  alias Api.AuthToken

  def index(conn, _params) do
    auth_token = Repo.all(AuthToken)
    render(conn, "index.json", auth_token: auth_token)
  end

  def create(conn, %{"auth_token" => auth_token_params}) do
    changeset = AuthToken.changeset(%AuthToken{}, auth_token_params)

    case Repo.insert(changeset) do
      {:ok, auth_token} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", auth_token_path(conn, :show, auth_token))
        |> render("show.json", auth_token: auth_token)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    auth_token = Repo.get!(AuthToken, id)
    render(conn, "show.json", auth_token: auth_token)
  end

  def update(conn, %{"id" => id, "auth_token" => auth_token_params}) do
    auth_token = Repo.get!(AuthToken, id)
    changeset = AuthToken.changeset(auth_token, auth_token_params)

    case Repo.update(changeset) do
      {:ok, auth_token} ->
        render(conn, "show.json", auth_token: auth_token)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    auth_token = Repo.get!(AuthToken, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(auth_token)

    send_resp(conn, :no_content, "")
  end
end
