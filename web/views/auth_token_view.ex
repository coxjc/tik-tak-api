defmodule Api.AuthTokenView do
  use Api.Web, :view

  def render("index.json", %{auth_token: auth_token}) do
    %{data: render_many(auth_token, Api.AuthTokenView, "auth_token.json")}
  end

  def render("show.json", %{auth_token: auth_token}) do
    %{data: render_one(auth_token, Api.AuthTokenView, "auth_token.json")}
  end

  def render("auth_token.json", %{auth_token: auth_token}) do
    %{id: auth_token.id,
      token: auth_token.token,
      user_id: auth_token.user_id,
      valid: auth_token.valid}
  end
end
