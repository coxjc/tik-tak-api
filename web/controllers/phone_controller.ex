defmodule Api.PhoneController do
  use Api.Web, :controller

  alias Api.Phone
  alias Api.AuthToken
  alias Api.AuthTokenView

  def verify(conn, %{"number" => number, "code" => code}) do
    phone = Repo.preload(Repo.get_by(Phone, number: Phone.format_number(number)), :user)
    if Application.get_env(:twilex, :prod) && (phone === nil or phone.code != code or code === nil or phone.attempts > 3) do
      phone |> Phone.add_attempt_changeset |> Repo.update!
      conn
      |> put_status(:unprocessable_entity)
      |> (fn c -> if phone.attempts > 3 do c |> json(%{error: "Out of attempts"}) else c |> json(%{error: "Invalid credentials"}) end end).()
    else
      # TODO simplify this shit.. there is way too much going on here
      # i promise im not an idiot
      if not phone.verified do
        changeset = Phone.verify_changeset(phone)
        Repo.update!(changeset)
      end
      auth_token_changeset = AuthToken.login_changeset(%AuthToken{}, %{user: phone.user})
      phone_changeset = phone |> Phone.use_code_changeset
      Repo.preload(phone.user, :auth_tokens).auth_tokens |> (fn x -> if x do x |> AuthToken.logout_changeset
      |> Repo.update! end end).()
      token = Repo.insert!(auth_token_changeset)
      phone = Repo.update!(phone_changeset)
      conn |> put_status(:created) |> render(AuthTokenView, "auth_token.json", %{auth_token: token, user_id: phone.user.id})
    end
  end

end
