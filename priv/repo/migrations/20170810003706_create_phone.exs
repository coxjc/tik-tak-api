defmodule Api.Repo.Migrations.CreatePhone do
  use Ecto.Migration

  def change do
    create table(:phone, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :number, :string
      add :code, :string
      add :code_sent, :datetime
      add :verified, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:phone, [:number])

  end
end
