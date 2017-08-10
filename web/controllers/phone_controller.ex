defmodule Api.PhoneController do
  use Api.Web, :controller

  alias Api.Phone

  def verify(conn, %{"number" => number, "code" => code}) do
    phone = Repo.get_by(Phone, number: Phone.format_number(number))
    if phone === nil or phone.code != code do 
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{error: "Invalid credentials"})
    else
      if not phone.verified do
        changeset = Phone.verify_changeset(phone)
        Repo.update!(changeset)
      end
      conn |> json(%{message: "Verified"})
    end
  end

end
