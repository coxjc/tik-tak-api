defmodule Api.Post do
  use Api.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id

  schema "post" do
    field :content, :string
    field :score, :integer, default: 0
    field :lat, :float, default: nil
    field :lng, :float, default: nil
    field :rating, :float, virtual: true, default: 0
    field :visible, :boolean, default: true

    field :is_comment, :boolean, default: false
    field :parent_id, :binary_id, default: nil 

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

  def comment_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :parent_id])
    |> validate_required([:content, :parent_id])
    |> put_assoc(:user, params.user)
    |> put_change(:is_comment, true)
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
