defmodule Api.UserView do
  use Api.Web, :view

  def render("index.json", %{user: user}) do
    %{data: render_many(user, Api.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Api.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      phone_id: user.phone_id,
      uuid: user.uuid,
      lat: user.lat,
      lng: user.lng,
      suspended: user.suspended,
      suspended_until: user.suspended_until,
      expelled: user.expelled}
  end
end
