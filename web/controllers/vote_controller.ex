defmodule Api.VoteController do
  use Api.Web, :controller

  import Ecto.Query

  alias Api.Vote
  alias Api.User
  alias Api.Post

  def vote(conn, %{"post_id" => post_id, "score" => score}) do
    user = conn.assigns.user
    # see if the post exists
    if score == 1 or score == 0 or score == -1 do
      case Repo.preload(Repo.get(Post, post_id), :user) do
        # if the post does not exist, abort
        nil -> 
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{error: "Post unavailable"}) 
        # call the found post `post`
        post ->
          # find a vote for the user by the calling user
          poster =  post.user
          case (from(v in Vote, where: v.user_id == ^(user.id) and v.post_id == ^post_id) |> Repo.one) do
            # if the user has not voted on the post
            nil -> 
              changeset = Vote.changeset(%Vote{}, %{user: user, post: post, score: score})
              case score do
                1 -> 
                  User.incr_takarma_changeset(poster) |> Repo.update!
                -1 -> 
                  User.decr_takarma_changeset(poster) |> Repo.update!
                _ ->
                  IO.puts "this is odd"
              end
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
              case cur_vote.score do
                1 -> 
                  case score do
                    1 -> 
                      IO.puts "do nothing"
                    0 ->
                      User.decr_takarma_changeset(poster) |> Repo.update!
                    -1 ->
                      User.double_decr_takarma_changeset(poster) |> Repo.update!
                  end
                -1 -> 
                  case score do
                    1 -> 
                      User.double_incr_takarma_changeset(poster) |> Repo.update!
                    0 ->
                      User.incr_takarma_changeset(poster) |> Repo.update!
                    -1 ->
                      IO.puts "do nothing"
                  end
                0 ->
                  case score do
                    1 -> 
                      User.incr_takarma_changeset(poster) |> Repo.update!
                    0 ->
                      IO.puts "do nothing"
                    -1 ->
                      User.decr_takarma_changeset(poster) |> Repo.update!
                  end
                _ ->
                  IO.puts "this should not happen"
              end
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
    else
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "what the fuck"})
    end
  end

end
