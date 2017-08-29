defmodule Api.Post do
  use Api.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id

  schema "post" do
    field :content, :string
    field :score, :integer, default: 0
    field :lat, :float
    field :lng, :float
    field :rating, :float, virtual: true, default: 0
    field :visible, :boolean, default: true

    belongs_to :user, Api.User
    has_many :votes, Api.Vote
    has_many :flags, Api.Flag

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
    |> cast(params, [:score])
    |> validate_required([:score])
  end

  def hide_post_changeset(struct, params \\ %{visible: false}) do
    struct
    |> cast(params, [:visible])
  end

end
