defmodule Api.PostView do
  use Api.Web, :view

  def render("index.json", %{post: post}) do
    %{posts: render_many(post, Api.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{post: render_one(post, Api.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      content: post.content,
      score: post.score,
      inserted_at: post.inserted_at,
      rating: post.rating,
      visible: post.visible,
      is_comment: post.is_comment,
      parent_id: post.parent_id
    }
  end
end
