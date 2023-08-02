defmodule ManacaWeb.CardController do
  use ManacaWeb, :controller

  alias Manaca.Accounts
  alias Manaca.Accounts.User

  action_fallback ManacaWeb.FallbackController

  def show(conn, %{"id" => id}) do
    case Accounts.get_user_by_card_id(id) do
      nil ->
        {:error, :not_found}

      user ->
        render(conn, :show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Accounts.get_user_by_card_id(id) do
      nil ->
        {:error, :not_found}

      user ->
        with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
          render(conn, :show, user: user)
        end
    end
  end
end
