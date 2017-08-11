defmodule Api.AuthToken do
  use Api.Web, :model

  schema "auth_token" do
    field :token, :string
    field :valid, :boolean, default: true 
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

  def login_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> put_assoc(:user, params.user)
    |> validate_required([:user]) 
    |> add_token
  end

  defp add_token(changeset) do
    changeset
    |> Ecto.Changeset.put_change(:token, generate_uuid())
  end

  defp generate_uuid() do
    UUID.uuid1()
  end

end
