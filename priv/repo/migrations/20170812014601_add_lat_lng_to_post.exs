defmodule Api.Repo.Migrations.AddLatLngToPost do
  use Ecto.Migration

  def change do
    alter table(:post) do
      add :lat, :float
      add :lng, :float
    end
  end

end
