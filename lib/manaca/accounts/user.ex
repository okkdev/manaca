defmodule Manaca.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  schema "users" do
    field :tokens, :integer, default: 0
    field :name, :string
    field :email, :string
    field :card_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :card_id, :tokens])
    # |> validate_required([:name, :email, :card_id, :tokens])
    |> validate_required([:card_id, :tokens])
    # |> validate_format(:email, ~r/@/)
    |> validate_number(:tokens, greater_than_or_equal_to: 0)
    |> unique_constraint(:email)
    |> unique_constraint(:card_id)
  end
end
