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
    field :comment_count, :integer, default: 0 

    field :is_comment, :boolean, default: false
    field :is_admin, :boolean, default: false
    field :parent_id, :binary_id, default: nil 

    belongs_to :user, Api.User
    has_many :votes, Api.Vote
    has_many :flags, Api.Flag
    has_one :food, Api.Food

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :lat, :lng, :is_admin])
    |> validate_required([:content, :lat, :lng, :is_admin])
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

  def incr_comment_count_changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [])
    |> put_change(:comment_count, struct.comment_count + 1)
  end

  def decr_comment_count_changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [])
    |> put_change(:comment_count, struct.comment_count - 1)
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
