defmodule Api.Repo.Migrations.CreateFlag do
  use Ecto.Migration

  def change do
    create table(:flag) do
      add :reason, :string
      add :active, :boolean, default: false, null: false
      add :flagger_id, references(:user, on_delete: :nothing)
      add :post_id, references(:post, on_delete: :nothing)

      timestamps()
    end
    create index(:flag, [:flagger_id])
    create index(:flag, [:post_id])

  end
end
