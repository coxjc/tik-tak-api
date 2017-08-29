defmodule Api.Repo.Migrations.CreateFlag do
  use Ecto.Migration

  def change do
    create table(:flag, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :reason, :string
      add :active, :boolean, default: false, null: false
      add :flagger_id, references(:user, on_delete: :nothing, type: :uuid)
      add :post_id, references(:post, on_delete: :nothing, type: :uuid)

      timestamps()
    end
    create index(:flag, [:flagger_id])
    create index(:flag, [:post_id])

  end
end
