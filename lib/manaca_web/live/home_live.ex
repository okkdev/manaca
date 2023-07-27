defmodule ManacaWeb.HomeLive do
  use ManacaWeb, :live_view

  alias Manaca.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div id="ring" class="p-20 rounded-xl outline outline-8">
      <div class="flex justify-center items-center h-full">
        Scan manaCard
      </div>
    </div>
    <form
      id="card_id_form"
      class="absolute w-0 h-0 opacity-0 pointer-events-none"
      phx-change={JS.push("check_id") |> JS.dispatch("manaca:reset_form", to: "#card_id_form")}
    >
      <input
        id="card_id_input"
        name="card_id"
        type="text"
        phx-hook="RingStatus"
        phx-mounted={JS.focus()}
        phx-blur={JS.focus()}
        phx-debounce="500"
      />
      <input type="reset" />
    </form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("check_id", %{"card_id" => card_id}, socket) do
    IO.inspect(card_id)

    case Accounts.get_user_by_card_id(card_id) do
      nil ->
        {:noreply, socket}

      user ->
        IO.inspect(user)
        {:noreply, push_navigate(socket, to: ~p"/users/#{user.id}/edit")}
    end
  end
end
