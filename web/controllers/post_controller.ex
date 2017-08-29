defmodule Api.PostController do
  use Api.Web, :controller

  alias Api.Post
  alias Api.Vote

  defp range_in_miles, do: 5
  defp gravity, do: 3

  def index(conn, %{"lat" => lat, "lng" => lng, "max" => max, "format" => format}) do
    # TODO there is too much going on here. having to query from posts twice. works for now so fuck it
    case format do
      "new" ->
        posts = Enum.map(new_post_ids(lat, lng, range_in_miles, max), fn([head|tail]) -> head end) |> visible_posts_from_ids
      _ ->
      posts = Enum.map(hot_post_ids(lat, lng, range_in_miles, gravity, max), fn([head|tail]) -> head end) |> visible_posts_from_ids 
              |> Enum.map(fn(post) -> Map.put(post, :rating, calc_rating(post, gravity)) end)
    end
    render(conn, "index.json", post: posts)
  end

  def index(conn, %{"lat" => lat, "lng" => lng, "max" => max}) do
    # TODO there is too much going on here. having to query from posts twice. works for now so fuck it
    posts = Enum.map(hot_post_ids(lat, lng, range_in_miles, gravity, max), fn([head|tail]) -> head end) |> visible_posts_from_ids
              |> Enum.map(fn(post) -> Map.put(post, :rating, calc_rating(post, gravity)) end)
    render(conn, "index.json", post: posts)
  end

  def my_posts(conn, _param) do
    user_id = conn.assigns.user.id
    posts = from(p in Post, where: p.user_id == ^user_id) |> Repo.all
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

  def update(conn, %{"id" => id, "visible" => visible}) do
    post = Repo.get!(Post, id)
    changeset = Post.hide_post_changeset(post, %{visible: visible})

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

  defp visible_posts_from_ids(ids) do
    from(p in Post, where: p.id in ^ids and p.visible == true) |> Repo.all
  end

  defp calc_rating(post, gravity) do
    (post.score / :math.pow(hours_old(post) + 2,  gravity))
  end

  defp hours_old(post) do
  post_time = NaiveDateTime.to_erl(post.inserted_at) |> :calendar.datetime_to_gregorian_seconds
  cur_time = NaiveDateTime.utc_now |> NaiveDateTime.to_erl |> :calendar.datetime_to_gregorian_seconds
  (cur_time - post_time) / 3600
  end

############################################
## Eventually, I should probably clean up these queries
############################################

  defp new_post_ids(lat, lng, distance, max) do
    case Ecto.Adapters.SQL.query(Repo, "SELECT id, ( 3959 * acos ( cos ( radians(?) ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(?) ) + sin ( radians(?) ) * sin( radians( lat ) ) ) ) AS distance FROM post HAVING distance < ? ORDER BY inserted_at DESC LIMIT 0 , ?", [lat, lng, lat, distance, max]) do
      {:ok, %Mariaex.Result{rows: rows}} ->
        rows
      error ->
        []
    end
  end

  #https://medium.com/hacking-and-gonzo/how-hacker-news-ranking-algorithm-works-1d9b0cf2c08d
  defp hot_post_ids(lat, lng, distance, gravity, max) do
    {{_, _, _}, {hour, _, _}} = :os.timestamp |> :calendar.now_to_datetime
    case Ecto.Adapters.SQL.query(Repo, "SELECT id, ( 3959 * acos ( cos ( radians(?) ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(?) ) + sin ( radians(?) ) * sin( radians( lat ) ) ) ) AS distance, (score / (POWER(( SELECT (UNIX_TIMESTAMP(UTC_TIMESTAMP())-UNIX_TIMESTAMP(inserted_at)) / 3600) + 2, ?))) as rating FROM post HAVING distance < ? ORDER BY rating DESC LIMIT 0 , ?", [lat, lng, lat, gravity, distance, max]) do
      {:ok, %Mariaex.Result{rows: rows}} ->
        rows
      error ->
        []
    end
  end

end
