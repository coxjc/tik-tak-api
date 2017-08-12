defmodule Api.UserView do
  use Api.Web, :view

  def render("index.json", %{user: user}) do
    render_many(user, Api.UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, Api.UserView, "user.json")
  end

  def render("user.json", %{user: user, phone: phone}) do
      render("user.json", %{user: user})
  end

  def render("user.json", %{user: user}) do
    %{
      user: %{
        lat: user.lat,
        lng: user.lng,
        suspended: user.suspended,
        suspended_until: user.suspended_until,
        expelled: user.expelled
      }
    }
  end

end
