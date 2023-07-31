defmodule ManacaWeb.CardController do
  use ManacaWeb, :controller

  alias Manaca.Accounts
  alias Manaca.Accounts.User

  action_fallback ManacaWeb.FallbackController

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user_by_card_id(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user_by_card_id(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end
end
