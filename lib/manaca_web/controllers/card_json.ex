defmodule ManacaWeb.CardJSON do
  alias Manaca.Accounts.User

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      card_id: user.card_id,
      tokens: user.tokens,
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email
    }
  end
end
