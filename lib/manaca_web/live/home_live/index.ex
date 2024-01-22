defmodule ManacaWeb.HomeLive.Index do
  use ManacaWeb, :live_view

  alias Manaca.Accounts
  alias Manaca.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("check_id", %{"card_id" => card_id}, socket) do
    # workaround for chinese reader which reads bytes in reverse
    card_id = reverse_byte_order(card_id)

    socket =
      case Accounts.get_user_by_card_id(card_id) do
        nil when byte_size(card_id) >= 6 ->
          with {:ok, new_user} <- Accounts.create_user(%{card_id: card_id}) do
            assign(socket, user: new_user)
          else
            _ -> socket
          end

        nil ->
          socket

        user ->
          assign(socket, user: user)
      end

    {:noreply, push_event(socket, "click", %{to: "#card_id_reset"})}
  end

  @impl true
  def handle_event("close_user", _, socket),
    do: {:noreply, assign(socket, user: nil, creating_user: false)}

  @impl true
  def handle_event("subtract-" <> num, _, socket) do
    {:ok, user} =
      Accounts.update_user(socket.assigns.user, %{
        tokens: socket.assigns.user.tokens - String.to_integer(num)
      })

    {:noreply, assign(socket, user: user)}
  end

  @impl true
  def handle_event("add-" <> num, _, socket) do
    {:ok, user} =
      Accounts.update_user(socket.assigns.user, %{
        tokens: socket.assigns.user.tokens + String.to_integer(num)
      })

    {:noreply, assign(socket, user: user)}
  end

  defp reverse_byte_order(<<>>), do: <<>>

  defp reverse_byte_order(<<byte::binary-size(2), rest::binary>>) do
    <<reverse_byte_order(rest)::binary, byte::binary>>
  end

  defp reverse_byte_order(x) when is_binary(x), do: x
end
