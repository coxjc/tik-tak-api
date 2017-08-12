defmodule Api.PostController do
  use Api.Web, :controller

  alias Api.Post
  alias Api.Vote


  def index(conn, _params) do
    render(conn, "index.json", post: Enum.map(Repo.all(Post), (fn(x) -> Map.put(x, :score, sum_score x) end)))
  end

  def create(conn, %{"content" => content, "lat" => lat, "lng" => lng}) do
    user = conn.assigns.user
    changeset = Post.create_changeset(%Post{}, %{user: user, content: content, lat: lat, lng: lng})

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> render("show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    post = Map.put(post, :score, sum_score(post)) 
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        render(conn, "show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    send_resp(conn, :no_content, "")
  end

  defp sum_score(post) do
    from(v in Vote, where: v.post_id == ^(post.id)) |> Repo.all |> Enum.map(fn(x) -> x.score end) |> Enum.sum
  end

end
