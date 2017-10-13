defmodule Api.Repo.Migrations.AddTakarmaToUser do
  use Ecto.Migration

  def change do
    alter table(:user) do
      add :takarma, :integer, default: 100
    end
  end
end
