defmodule Api.Post do
  use Api.Web, :model

  schema "post" do
    field :content, :string
    field :upvotes, :integer, default: 0
    field :downvotes, :integer, default: 0 
    field :visible, :boolean, default: true

    belongs_to :user, Api.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
    |> put_assoc(:user, params.user)
    |> validate_length(:content, min: 1, max: 140)
  end

end
