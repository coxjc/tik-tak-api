defmodule Api.PhoneController do
  use Api.Web, :controller

  alias Api.Phone
  alias Api.AuthToken
  alias Api.AuthTokenView

  def verify(conn, %{"number" => number, "code" => code}) do
    phone = Repo.preload(Repo.get_by(Phone, number: Phone.format_number(number)), :user)
    if phone === nil or phone.code != code or code === nil do 
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{error: "Invalid credentials"})
    else
      if not phone.verified do
        changeset = Phone.verify_changeset(phone)
        Repo.update!(changeset)
      end
      auth_token_changeset = AuthToken.login_changeset(%AuthToken{}, %{user: phone.user})
      phone_changeset = Phone.use_code_changeset(phone)
      Repo.preload(phone.user, :auth_tokens).auth_tokens |> AuthToken.logout_changeset |> Repo.update! 
      token = Repo.insert!(auth_token_changeset)
      phone = Repo.update!(phone_changeset)
      conn |> put_status(:created) |> render(AuthTokenView, "auth_token.json", %{auth_token: token})
    end
  end

end
