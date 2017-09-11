defmodule Api.Repo.Migrations.AddCommentFieldsToPost do
  use Ecto.Migration

  def change do
    alter table(:post) do
      add :is_comment, :boolean, default: false
      add :parent_id, references(:post, on_delete: :nothing, type: :uuid), default: nil
    end
  end
end
