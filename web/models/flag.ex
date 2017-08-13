defmodule Api.Flag do
  use Api.Web, :model

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
    |> cast(params, [:reason, :active])
    |> validate_required([:reason, :active])
    |> put_assoc(:post, params.post)
    |> put_assoc(:flagger, params.flagger)
  end
end
