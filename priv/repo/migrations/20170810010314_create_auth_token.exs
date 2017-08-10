defmodule Api.Repo.Migrations.CreateAuthToken do
  use Ecto.Migration

  def change do
    create table(:auth_token) do
      add :token, :string
      add :valid, :boolean, default: false, null: false
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end
    create index(:auth_token, [:user_id])

  end
end
