defmodule Api.Phone do
  use Api.Web, :model

  alias Api.Repo

  @phone_regex ~r/^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})?\s*$/ 

  schema "phone" do
    field :number, :string
    field :code, :string
    field :code_sent, Ecto.DateTime
    field :verified, :boolean, default: false
    has_one :user, Api.User

    timestamps()
  end

  def register_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number])
    |> validate_required([:number])
    |> format_number
  end

  defp format_number(changeset) do
    case Regex.match?(@phone_regex, changeset.changes.number) do
      true ->
        # parse the phone number into specific format
        number = Regex.replace(@phone_regex, changeset.changes.number, "\\1-\\2-\\3-\\4") 
        # if the phone number did not include a country code, add USA 1 to beginning 
        if String.slice(number, 0..0) == "-" do
          number = String.replace_leading(number, "-", "1-")
        end
        changeset 
        |> put_change(:number, number)
      false ->
        changeset 
        |> add_error(:number, "Invalid format")
    end
  end

end
