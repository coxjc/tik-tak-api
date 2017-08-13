defmodule Api.PostController do
  use Api.Web, :controller

  alias Api.Post
  alias Api.Vote

  def index(conn, %{"lat" => lat, "lng" => lng, "range" => radius, "max" => max, "format" => format}) do
    # TODO there is too much going on here. having to query from posts twice. works for now so fuck it
    case format do
      "new" ->
        posts = Enum.map(new_post_ids(lat, lng, radius, max), fn([head|tail]) -> head end) |> posts_from_id
      _ ->
        posts = Enum.map(hot_post_ids(lat, lng, radius, 3, max), fn([head|tail]) -> head end) |> posts_from_id
    end
    render(conn, "index.json", post: posts)
  end

  def index(conn, %{"lat" => lat, "lng" => lng, "range" => radius, "max" => max}) do
    # TODO there is too much going on here. having to query from posts twice. works for now so fuck it
    posts = Enum.map(hot_post_ids(lat, lng, radius, 3, max), fn([head|tail]) -> head end) |> posts_from_id
    render(conn, "index.json", post: posts)
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

  defp posts_from_id(ids) do
    from(p in Post, where: p.id in ^ids) |> Repo.all
  end

  defp new_post_ids(lat, lng, distance, max) do
    case Ecto.Adapters.SQL.query(Repo, "SELECT id, ( 3959 * acos ( cos ( radians(?) ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(?) ) + sin ( radians(?) ) * sin( radians( lat ) ) ) ) AS distance FROM post HAVING distance < ? ORDER BY inserted_at DESC LIMIT 0 , ?", [lat, lng, lat, distance, max]) do
      {:ok, %Mariaex.Result{rows: rows}} ->
        rows
      error -> 
        IO.inspect error 
        []
    end
  end

  defp hot_post_ids(lat, lng, distance, gravity, max) do
    {{_, _, _}, {hour, _, _}} = :os.timestamp |> :calendar.now_to_datetime
    case Ecto.Adapters.SQL.query(Repo, "SELECT id, ( 3959 * acos ( cos ( radians(?) ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(?) ) + sin ( radians(?) ) * sin( radians( lat ) ) ) ) AS distance, (score / (POWER(( SELECT (UNIX_TIMESTAMP(NOW())-UNIX_TIMESTAMP(inserted_at)) / 3600 + 2), ?))) as rating FROM post HAVING distance < ? ORDER BY rating DESC LIMIT 0 , ?", [lat, lng, lat, gravity, distance, max]) do
      {:ok, %Mariaex.Result{rows: rows}} ->
        rows
      error -> 
        IO.inspect error
        []
    end
  end
end


