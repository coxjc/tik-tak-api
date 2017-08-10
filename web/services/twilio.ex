defmodule ApiServer.Messenger do
  import Twilex
  alias Twilex.Messenger

  def send_verification_sms(%{number: number, verification_code: code}) do
    msg = Messenger.create(Application.get_env(:twilex, :from_number), number, "Your verification code is: #{code}")
    case msg do
      %{code: response_code, message: response_message} -> 
        IO.puts "Sent #{code} to #{number}"
      _ -> 
        IO.puts "Error sending #{code} to #{number}"
    end
  end

end
