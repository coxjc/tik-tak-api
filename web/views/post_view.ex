defmodule Api.PostView do
  use Api.Web, :view

  def render("index.json", %{post: post}) do
    %{data: render_many(post, Api.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Api.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      content: post.content,
      upvotes: post.upvotes,
      downvotes: post.downvotes,
      visible: post.visible}
  end
end
