defmodule Api.Post do
  use Api.Web, :model

  schema "post" do
    field :content, :string
    field :upvotes, :integer
    field :downvotes, :integer
    field :visible, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :upvotes, :downvotes, :visible])
    |> validate_required([:content, :upvotes, :downvotes, :visible])
  end
end
