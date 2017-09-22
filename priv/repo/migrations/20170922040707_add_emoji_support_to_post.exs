defmodule Api.Repo.Migrations.AddEmojiSupportToPost do
  use Ecto.Migration

  def change do
    execute """
          ALTER TABLE post CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
    """
    execute """
      ALTER TABLE post MODIFY content VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
    """
    execute """
      ALTER DATABASE #{Keyword.get(Api.Repo.config, :database)} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
    """
  end
end
