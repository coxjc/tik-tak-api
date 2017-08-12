defmodule Api.VoteView do
  use Api.Web, :view

  def render("index.json", %{vote: vote}) do
    %{data: render_many(vote, Api.VoteView, "vote.json")}
  end

  def render("show.json", %{vote: vote}) do
    %{data: render_one(vote, Api.VoteView, "vote.json")}
  end

  def render("vote.json", %{vote: vote}) do
    %{id: vote.id,
      score: vote.score,
      post_id: vote.post_id,
      user_id: vote.user_id}
  end
end
