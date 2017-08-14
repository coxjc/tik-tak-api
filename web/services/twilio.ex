defmodule Api.Twilio do
  import Twilex
  alias Twilex.Messenger

  def send_verification_sms(%{number: number, verification_code: code}) do
    msg = Messenger.create(Application.get_env(:twilex, :from_number), number, "Your verification code is: #{code}")
    case msg do
      %{code: response_code, message: response_message} ->
        IO.puts "Sent #{code} to #{number}"
      error ->
        IO.inspect(error)
        IO.puts "Error sending #{code} to #{number}"
    end
  end

  def phone_number_is_mobile?(%{number: number}) do
    resp = HTTPoison.get!("https://#{Application.get_env(:twilex, :sid)}:#{Application.get_env(:twilex, :token)}@lookups.twilio.com/v1/PhoneNumbers/#{number}?CountryCode=US&Type=carrier", [], [])
    case resp do
      %HTTPoison.Response{status_code: 200, body: body} ->
        case Poison.Parser.parse!(body) do
          %{"carrier" => %{"type" => "mobile"}} ->
            true
          _ ->
            false
        end
      _ ->
        #false
        true
    end
  end

  def flag_notify(flag_id) do
    msg = Messenger.create(Application.get_env(:twilex, :from_number), Application.get_env(:twilex, :flag_notify_number), "A post has been flagged! Flag ID: #{flag_id}")
    case msg do
      %{code: response_code, message: response_message} ->
        IO.puts response_message 
        IO.puts "Notified"
      error ->
        IO.inspect(error)
        IO.puts "Error notifying"
    end
  end

end
