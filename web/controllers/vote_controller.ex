defmodule Api.VoteController do
  use Api.Web, :controller

  import Ecto.Query

  alias Api.Vote
  alias Api.Post

  def vote(conn, %{"post_id" => post_id, "score" => score}) do
    user = conn.assigns.user
    # see if the post exists
    case Repo.get(Post, post_id) do
      # if the post does not exist, abort
      nil -> 
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Post unavailable"}) 
      # call the found post `post`
      post ->
        # find a vote for the user by the calling user
        case (from(v in Vote, where: v.user_id == ^(user.id) and v.post_id == ^post_id) |> Repo.one) do
          # if the user has not voted on the post
          nil -> 
            changeset = Vote.changeset(%Vote{}, %{user: user, post: post, score: score})
            case Repo.insert(changeset) do
              {:ok, vote} ->
                # update post's score based on past post score and user's vote
                upd_post = Post.update_score_changeset(post, %{score: post.score + vote.score}) |> Repo.update!
                conn
                |> put_status(:created)
                |> json(%{vote: vote.score, score: upd_post.score})
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(Api.ChangesetView, "error.json", changeset: changeset)
            end
          # if the user has already voted
          cur_vote ->
            # calculate the new score of the vote based on the difference between the old vote's score and the new
            new_score = score - cur_vote.score 
            case Repo.update(Vote.update_changeset(cur_vote, %{score: score})) do
              {:ok, vote} ->
                # update post's score based on past post score and user's vote
                upd_post = Post.update_score_changeset(post, %{score: (post.score + new_score)}) |> Repo.update!
                conn
                |> put_status(:created)
                |> json(%{vote: vote.score, score: upd_post.score})
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(Api.ChangesetView, "error.json", changeset: changeset)
            end
        end
    end
  end

end
