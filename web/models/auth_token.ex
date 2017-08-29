defmodule Api.AuthToken do
  use Api.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id

  schema "auth_token" do
    field :token, :string
    field :valid, :boolean, default: true
    belongs_to :user, Api.User

    timestamps()
  end

  def login_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> put_assoc(:user, params.user)
    |> validate_required([:user])
    |> add_token
  end

  def logout_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> put_change(:valid, false)
  end

  # returns true if the token is within lifespan and hasn't been logged out
  def valid?(auth_token_record) do
    auth_token_record != nil && auth_token_record.valid
  end

  defp add_token(changeset) do
    changeset
    |> Ecto.Changeset.put_change(:token, generate_uuid())
  end

  defp generate_uuid() do
    # TODO probs not a good way to do this
    UUID.uuid1() <> UUID.uuid1 <> UUID.uuid1
  end

end
