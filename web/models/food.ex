defmodule Api.Food do
  use Api.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id

  schema "food" do
    field :location_string, :string
    field :expires_at, Ecto.DateTime
    belongs_to :post, Api.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:location_string, :expires_at])
    |> validate_required([:location_string, :expires_at])
  end
end
