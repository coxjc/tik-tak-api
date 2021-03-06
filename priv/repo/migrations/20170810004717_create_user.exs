defmodule Api.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :lat, :float
      add :lng, :float
      add :suspended, :boolean, default: false, null: false
      add :suspended_until, :datetime
      add :expelled, :boolean, default: false, null: false
      add :phone_id, references(:phone, on_delete: :nothing, type: :uuid)

      timestamps()
    end
    create index(:user, [:phone_id])

  end
end
