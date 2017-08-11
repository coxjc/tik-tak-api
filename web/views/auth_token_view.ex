defmodule Api.AuthTokenView do
  use Api.Web, :view

  def render("show.json", %{auth_token: auth_token}) do
    render_one(auth_token, Api.AuthTokenView, "auth_token.json")
  end

  def render("auth_token.json", %{auth_token: auth_token}) do
    %{token: auth_token.token,}
  end
end
