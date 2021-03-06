defmodule Api.Phone do
  use Api.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id

  alias Api.Repo

  @phone_regex ~r/^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})?\s*$/

  schema "phone" do
    field :number, :string
    field :code, :string
    field :code_sent, Ecto.DateTime
    field :attempts, :integer, default: 0
    field :verified, :boolean, default: false
    has_one :user, Api.User

    timestamps()
  end

  def register_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number])
    |> validate_required([:number])
    |> put_format_number
    |> put_change(:code_sent, Ecto.DateTime.utc)
    |> put_change(:attempts, 0)
    |> unique_constraint(:number)
    |> put_code
  end

  def login_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> put_change(:attempts, 0)
    |> put_code
  end

  def use_code_changeset(struct, params \\ %{})  do
    struct
    |> cast(params, [])
    |> put_change(:verified, true)
    |> put_change(:code, nil)
    |> put_change(:code_sent, nil)
    |> put_change(:attempts, nil)
  end

  def add_attempt_changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [])
    |> put_change(:attempts, struct.attempts + 1)
  end

  defp put_format_number(changeset) do
    case format_number(changeset.changes.number) do
      nil ->
        changeset
        |> add_error(:number, "Invalid format")
      number ->
        changeset
        |> put_change(:number, number)
    end
  end

  def format_number(param) do
    case Regex.match?(@phone_regex, param) do
      true ->
        # parse the phone number into specific format
        number = Regex.replace(@phone_regex, param, "\\1-\\2-\\3-\\4")
        # if the phone number did not include a country code, add USA 1 to beginning
        if String.slice(number, 0..0) == "-" do
          number = String.replace_leading(number, "-", "1-")
        end
        number
      false ->
        nil
    end
  end

  # changeset used to verify someone's number
  def verify_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [], [])
    |> put_change(:verified, true)
  end

  # random code generator for sms
  # puts code in changeset
  defp put_code(struct, params \\ %{}) do
    struct
    |> cast(params, [], [])
    |> put_change(:code, Integer.to_string(Enum.random(1000..9999)))
  end

end
