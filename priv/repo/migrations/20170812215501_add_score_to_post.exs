defmodule Api.Repo.Migrations.AddScoreToPost do
  use Ecto.Migration

  def change do
    alter table(:post) do
      add :score, :integer
    end
  end
end
