defmodule Api.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:post) do
      add :content, :string
      add :upvotes, :integer
      add :downvotes, :integer
      add :visible, :boolean, default: false, null: false

      timestamps()
    end

  end
end
