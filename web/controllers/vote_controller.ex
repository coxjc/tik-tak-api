defmodule Api.VoteController do
  use Api.Web, :controller

  import Ecto.Query

  alias Api.Vote
  alias Api.Post

  def vote(conn, %{"post_id" => post_id, "score" => score}) do
    user = conn.assigns.user
    user_id = user.id
    post = Repo.get(Post, 1)
    cur_vote = from(v in Vote, where: v.user_id == ^user_id and v.post_id == ^post_id) |> Repo.one
    if !cur_vote do
      if post && post.visible do
        changeset = Vote.changeset(%Vote{}, %{user: user, post: post, score: score})
        case Repo.insert(changeset) do
          {:ok, vote} ->
            conn
            |> put_status(:created)
            |> render("show.json", vote: vote)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Api.ChangesetView, "error.json", changeset: changeset)
        end
      else 
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{error: "Post unavailable"}) 
      end
    else 
      new_vote = Vote.update_changeset(cur_vote, %{score: score})
      case Repo.update(new_vote) do
          {:ok, vote} ->
            conn
            |> put_status(:created)
            |> render("show.json", vote: vote)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Api.ChangesetView, "error.json", changeset: changeset)
        end
    end
  end

end
