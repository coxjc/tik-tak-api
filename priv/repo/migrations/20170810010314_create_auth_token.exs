defmodule Api.Repo.Migrations.CreateAuthToken do
  use Ecto.Migration

  def change do
    create table(:auth_token, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :token, :string
      add :valid, :boolean, default: false, null: false
      add :user_id, references(:user, on_delete: :nothing, type: :uuid)

      timestamps()
    end
    create index(:auth_token, [:user_id])

  end
end
