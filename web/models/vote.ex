defmodule Api.Vote do
  use Api.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id

  schema "vote" do
    field :score, :integer
    belongs_to :post, Api.Post
    belongs_to :user, Api.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:score])
    |> put_assoc(:user, params.user)
    |> put_assoc(:post, params.post)
    |> validate_vote_range
    |> validate_required([:score])
  end

  def update_changeset(struct, params = %{score: score}) do
    struct
    |> cast(params, [:score])
    |> put_change(:score, score)
    |> validate_vote_range
  end

  defp validate_vote_range(changeset = %Ecto.Changeset{changes: %{score: score}}) do
    case score in [-1, 0, 1] do
      true ->
        changeset
      false ->
        changeset |> add_error(:score, "Invalid score")
    end
  end

  # if the new vote is not a change, then just return the original changeset
  defp validate_vote_range(changeset = %Ecto.Changeset{changes: %{}}) do
    changeset
  end

end
