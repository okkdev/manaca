defmodule Manaca.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, null: false, primary_key: true
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :card_id, :string
      add :tokens, :integer

      timestamps()
    end
  end
end
