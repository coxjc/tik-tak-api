defmodule Api.Repo.Migrations.AddCommentCountToPost do
  use Ecto.Migration

  def change do
    alter table(:post) do
      add :comment_count, :integer, default: 0
    end

  end
end
