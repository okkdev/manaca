defmodule Manaca.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Manaca.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        tokens: 42,
        firstname: "some firstname",
        lastname: "some lastname",
        email: "some email",
        card_id: "some card_id"
      })
      |> Manaca.Accounts.create_user()

    user
  end
end
