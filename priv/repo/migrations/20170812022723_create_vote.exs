defmodule Api.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:vote) do
      add :score, :integer
      add :post_id, references(:post, on_delete: :nothing)
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end
    create index(:vote, [:post_id])
    create index(:vote, [:user_id])

  end
end
