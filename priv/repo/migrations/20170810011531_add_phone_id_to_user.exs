defmodule Api.Repo.Migrations.AddPhoneIdToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :phone_id, references(:phones) 
    end
  end
end
