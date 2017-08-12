defmodule Api.Vote do
  use Api.Web, :model

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

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> put_change(:score, params.score)
    |> validate_vote_range
  end

  defp validate_vote_range(changeset) do
    case changeset.changes do
      %{score: score} ->
        IO.inspect changeset
        if score == -1 || score == 0 || score == 1 do
          changeset
        else 
          IO.inspect changeset
          changeset |> add_error(:score, "Invalid score")
        end
      _ ->
        changeset
    end
  end

end
