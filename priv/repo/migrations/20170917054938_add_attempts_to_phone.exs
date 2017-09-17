defmodule Api.Repo.Migrations.AddAttemptsToPhone do
  use Ecto.Migration

  def change do
    alter table(:phone) do
      add :attempts, :integer
    end
  end
end
