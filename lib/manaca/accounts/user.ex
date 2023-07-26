defmodule Manaca.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  schema "users" do
    field :tokens, :integer, default: 0
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :card_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :card_id, :tokens])
    |> validate_required([:firstname, :lastname, :email, :card_id, :tokens])
    |> validate_number(:tokens, greater_than_or_equal_to: 0)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:card_id)
  end
end
