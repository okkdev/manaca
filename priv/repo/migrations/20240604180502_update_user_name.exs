defmodule Manaca.Repo.Migrations.UpdateUserName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :lastname
    end

    rename table("users"), :firstname, to: :name
  end
end
