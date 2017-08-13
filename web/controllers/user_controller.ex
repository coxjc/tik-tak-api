defmodule Api.UserController do
  use Api.Web, :controller

  alias Api.User
  alias Api.Phone
  alias Api.AuthToken
  alias Api.Twilio

  def create(conn, %{"number" => phone_number, "lat" => lat, "lng" => lng}) do
    # check if there is already a user with this number. if so, send a code
    case Phone.format_number(phone_number) do
      nil ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Not a valid mobile phone number"})
      formatted_number ->
        case Repo.get_by(Phone, number: formatted_number) do
          nil ->
            case Twilio.phone_number_is_mobile?(%{number: formatted_number}) do
              false ->
                conn
                |> put_status(:unprocessable_entity)
                |> json(%{error: "Not a valid mobile phone number"})
              true ->
                phone_changeset = Phone.register_changeset(%Phone{}, %{number: formatted_number})
                case Repo.insert(phone_changeset) do
                  {:ok, phone} ->
                    user_changeset = User.register_changeset(%User{}, %{phone: phone, lat: lat, lng: lng})
                    case Repo.insert(user_changeset) do
                      {:ok, user} ->
                        Task.async(Twilio, :send_verification_sms, [%{number: phone.number, verification_code: phone.code}])
                        conn
                        |> put_status(:created)
                        |> json(%{message: "Register code sent to #{phone.number}"})
                      {:error, changeset} ->
                        Repo.delete!(phone)
                        conn
                        |> put_status(:unprocessable_entity)
                        |> render(Api.ChangesetView, "error.json", changeset: changeset)
                    end
                  {:error, changeset} ->
                    conn
                    |> put_status(:unprocessable_entity)
                    |> render(Api.ChangesetView, "error.json", changeset: changeset)
                end
            end
          cur_phone  ->
            phone_changeset = Phone.login_changeset(cur_phone)
            phone = Repo.update!(phone_changeset)
            Task.async(Twilio, :send_verification_sms, [%{number: cur_phone.number, verification_code: phone.code}])
            conn
            |> put_status(:created)
            |> json(%{message: "Login code sent to #{formatted_number}"})
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
