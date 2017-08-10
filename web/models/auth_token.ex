defmodule Api.AuthToken do
  use Api.Web, :model

  schema "auth_token" do
    field :token, :string
    field :valid, :boolean, default: false
    belongs_to :user, Api.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :valid])
    |> validate_required([:token, :valid])
  end
end
