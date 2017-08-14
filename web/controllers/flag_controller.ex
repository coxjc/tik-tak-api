defmodule Api.FlagController do
  use Api.Web, :controller

  alias Api.Flag
  alias Api.User
  alias Api.Post
  alias Api.Twilio

  def index(conn, _params) do
    flag = Repo.all(Flag)
    render(conn, "index.json", flag: flag)
  end

  def create(conn, %{"post_id" => post_id, "reason" => reason}) do
    flagger_id = conn.assigns.user.id
    cur_flag = Repo.get_by(Flag, post_id: post_id)
    #check if a flag already exists for this post
    case cur_flag do
      nil ->
        case Repo.get(User, flagger_id) do
          nil ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "User not found"})
          user ->
            case Repo.get(Post, post_id) do
              nil ->
                conn
                |> put_status(:unprocessable_entity)
                |> json(%{error: "User not found"})
              post ->
                # create a flag with the flagging user, the post, and why it's being flagged
                post_changeset = Flag.changeset(%Flag{}, %{flagger: conn.assigns.user, post: post, reason: reason})
                case Repo.insert(post_changeset) do
                  {:ok, flag} ->
                    Task.async(Twilio, :flag_notify, [flag.id])
                    conn
                    |> json(%{message: "Reported"})
                  {:error, error} ->
                    conn
                    |> put_status(:unprocessable_entity)
                    |> render(Api.ChangesetView, "error.json", changeset: error)
                end
            end
        end
      flag ->
        conn
        |> json(%{message: "Reported"})
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Flag, id) do
      nil ->
        conn |> put_status(:unprocessable_entity) |> json(%{message: "Flag not found"})
      flag ->
        render(conn, "show.json", flag: flag)
    end
  end

  def update(conn, %{"id" => id, "active" => active}) do
    case Repo.get(Flag, id) do
      nil ->
        conn |> put_status(:unprocessable_entity) |> json(%{message: "Flag not found"})
      flag ->
        changeset = Flag.update_flag_changeset(flag, %{active: active})
        case Repo.update(changeset) do
          {:ok, flag} ->
            conn |> json(%{message: "Flag updated"})
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Api.ChangesetView, "error.json", changeset: changeset)
        end
    end
  end

end
