defmodule Api.Flag do
  use Api.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id

  schema "flag" do
    field :reason, :string
    field :active, :boolean, default: true 
    belongs_to :flagger, Api.User
    belongs_to :post, Api.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:reason])
    |> validate_required([:reason])
    |> put_assoc(:post, params.post)
    |> put_assoc(:flagger, params.flagger)
  end

  def update_flag_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:active])
  end

end
