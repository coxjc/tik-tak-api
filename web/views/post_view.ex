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
      score: post.score
    }
  end
end
