defmodule Api.PostTest do
  use Api.ModelCase

  alias Api.Post

  @valid_attrs %{content: "some content", downvotes: 42, upvotes: 42, visible: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
