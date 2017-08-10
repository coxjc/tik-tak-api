defmodule Api.PhoneController do
  use Api.Web, :controller

  alias Api.Phone

  def index(conn, _params) do
    phone = Repo.all(Phone)
    render(conn, "index.json", phone: phone)
  end

  def create(conn, %{"phone" => phone_params}) do
    changeset = Phone.changeset(%Phone{}, phone_params)

    case Repo.insert(changeset) do
      {:ok, phone} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", phone_path(conn, :show, phone))
        |> render("show.json", phone: phone)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    phone = Repo.get!(Phone, id)
    render(conn, "show.json", phone: phone)
  end

  def update(conn, %{"id" => id, "phone" => phone_params}) do
    phone = Repo.get!(Phone, id)
    changeset = Phone.changeset(phone, phone_params)

    case Repo.update(changeset) do
      {:ok, phone} ->
        render(conn, "show.json", phone: phone)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    phone = Repo.get!(Phone, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(phone)

    send_resp(conn, :no_content, "")
  end
end
