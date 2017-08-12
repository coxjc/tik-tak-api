defmodule Api.User do
  use Api.Web, :model

  schema "user" do
    field :lat, :float
    field :lng, :float
    field :suspended, :boolean, default: false
    field :suspended_until, Ecto.DateTime, default: nil
    field :expelled, :boolean, default: false
    belongs_to :phone, Api.Phone
    has_one :auth_tokens, Api.AuthToken
    has_many :posts, Api.Post

    timestamps()
  end

  def register_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:lat, :lng])
    |> put_assoc(:phone, params.phone)
    |> validate_required([:lat, :lng])
  end

  def update_location_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:lat, :lng])
    |> validate_required([:lat, :lng])
  end

end
