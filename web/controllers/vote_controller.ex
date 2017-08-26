defmodule Api.VoteController do
  use Api.Web, :controller

  import Ecto.Query

  alias Api.Vote
  alias Api.Post

  def vote(conn, %{"post_id" => post_id, "score" => score}) do
    user = conn.assigns.user
    case Repo.get(Post, post_id) do
      nil -> 
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Post unavailable"}) 
      post ->
        case (from(v in Vote, where: v.user_id == ^(user.id) and v.post_id == ^post_id) |> Repo.one) do
          nil -> 
            changeset = Vote.changeset(%Vote{}, %{user: user, post: post, score: score})
            # update post's score based on past post score and user's vote
            post_changeset = Post.update_score_changeset(post, %{score: (post.score + score)})
            case Repo.insert(changeset) do
              {:ok, vote} ->
                Repo.update!(post_changeset)
                conn
                |> put_status(:created)
                |> render("show.json", vote: vote)
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(Api.ChangesetView, "error.json", changeset: changeset)
            end
          cur_vote ->
            new_vote = Vote.update_changeset(cur_vote, %{score: score})
            case Repo.update(new_vote) do
              {:ok, vote} ->
                if cur_vote.score != score do
                  # update post's score based on past post score and user's vote
                  post_changeset = Post.update_score_changeset(post, %{score: (post.score + score)})
                  Repo.update!(post_changeset)
                end
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

end
