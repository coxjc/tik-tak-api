defmodule Api.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:post, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :content, :string
      add :visible, :boolean, default: false, null: false

      timestamps()
    end

  end
end
