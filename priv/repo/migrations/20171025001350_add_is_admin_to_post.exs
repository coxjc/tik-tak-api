defmodule Api.Repo.Migrations.AddIsAdminToPost do
  use Ecto.Migration

  def change do
    alter table(:post) do
      add :is_admin, :boolean, default: false
    end
  end
end
