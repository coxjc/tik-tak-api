defmodule Api.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:vote, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :score, :integer
      add :post_id, references(:post, on_delete: :nothing, type: :uuid)
      add :user_id, references(:user, on_delete: :nothing, type: :uuid)

      timestamps()
    end
    create index(:vote, [:post_id])
    create index(:vote, [:user_id])

  end
end
