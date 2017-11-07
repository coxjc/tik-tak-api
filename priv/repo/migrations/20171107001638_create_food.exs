defmodule Api.Repo.Migrations.CreateFood do
  use Ecto.Migration

  def change do
    create table(:food, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :location_string, :string
      add :expires_at, :datetime
      add :post_id, references(:post, on_delete: :delete_all, type: :uuid)

      timestamps()
    end
    create index(:food, [:post_id])

  end
end
