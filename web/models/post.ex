defmodule Api.Post do
  use Api.Web, :model

  schema "post" do
    field :content, :string
    field :score, :integer, default: 0
    field :lat, :float
    field :lng, :float
    field :visible, :boolean, default: true

    belongs_to :user, Api.User
    has_many :votes, Api.Vote

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :lat, :lng])
    |> validate_required([:content, :lat, :lng])
    |> put_assoc(:user, params.user)
    |> validate_length(:content, min: 1, max: 140)
  end

  def update_score_changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [])
    |> put_change(:score, params.score)
  end

end
