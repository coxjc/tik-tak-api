defmodule Api.Phone do
  use Api.Web, :model

  schema "phone" do
    field :number, :string
    field :code, :string
    field :code_sent, Ecto.DateTime
    field :verified, :boolean, default: false
    belongs_to :user, Api.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number, :code, :code_sent, :verified])
    |> validate_required([:number, :code, :code_sent, :verified])
  end
end
