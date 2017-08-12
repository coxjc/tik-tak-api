defmodule Api.Repo.Migrations.AddUserIdToPost do
  use Ecto.Migration

  def change do
    alter table(:post) do
      add :user_id, references(:user, on_delete: :nothing)
    end
  end
end
