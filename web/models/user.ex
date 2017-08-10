defmodule Api.User do
  use Api.Web, :model

  schema "user" do
    field :uuid, Ecto.UUID
    field :lat, :string
    field :lng, :string
    field :suspended, :boolean, default: false
    field :suspended_until, Ecto.DateTime, default: nil
    field :expelled, :boolean, default: false
    has_one :phone, Api.Phone
    has_many :auth_tokens, Api.AuthToken

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uuid, :lat, :lng, :suspended, :suspended_until, :expelled])
    |> validate_required([:uuid, :lat, :lng, :suspended, :suspended_until, :expelled])
  end

  def register_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:phone_id, :lat, :lng])
    |> validate_required([:phone_id, :lat, :lng])
  end

  def update_location_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:lat, :lng])
    |> validate_required([:lat, :lng])
  end

end
