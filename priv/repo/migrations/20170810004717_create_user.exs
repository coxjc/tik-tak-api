defmodule Api.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :uuid, :uuid
      add :lat, :string
      add :lng, :string
      add :suspended, :boolean, default: false, null: false
      add :suspended_until, :datetime
      add :expelled, :boolean, default: false, null: false
      add :phone_id, references(:phone, on_delete: :nothing)

      timestamps()
    end
    create index(:user, [:phone_id])

  end
end
