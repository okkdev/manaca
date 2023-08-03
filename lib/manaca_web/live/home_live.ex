defmodule ManacaWeb.HomeLive do
  use ManacaWeb, :live_view

  alias Manaca.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div id="ring" class="p-10 rounded-2xl outline outline-8 outline-green-200">
      <%= if assigns[:user] do %>
        <div class="grid grid-cols-4 gap-5">
          <div class="col-span-4 text-center">
            <%= "#{@user.firstname} #{@user.lastname}" %>
          </div>

          <div class="col-span-4 py-5 font-bold text-center">
            <div class="text-4xl">
              <%= @user.tokens %>
            </div>
            <div>
              Tokens
            </div>
          </div>

          <button
            class="p-6 text-xl font-semibold bg-yellow-200 rounded hover:bg-yellow-300 disabled:bg-gray-300"
            disabled={@user.tokens - 10 < 0}
            phx-click="subtract-10"
          >
            - 10
          </button>
          <button
            class="p-6 text-xl font-semibold bg-yellow-100 rounded hover:bg-yellow-200 disabled:bg-gray-200"
            disabled={@user.tokens - 1 < 0}
            phx-click="subtract-1"
          >
            - 1
          </button>
          <button
            class="p-6 text-xl font-semibold bg-green-100 rounded hover:bg-green-200"
            phx-click="add-1"
          >
            + 1
          </button>
          <button
            class="p-6 text-xl font-semibold bg-green-200 rounded hover:bg-green-300"
            phx-click="add-10"
          >
            + 10
          </button>

          <div class="flex col-span-4 justify-center items-center">
            <button
              class="p-2 text-white bg-gray-300 rounded-full aspect-square hover:bg-gray-400"
              phx-click="close_user"
            >
              <.icon name="hero-x-mark" class="w-6 h-6" />
            </button>
          </div>
        </div>
      <% else %>
        <div class="flex justify-center items-center h-full">
          scan manaca
        </div>
      <% end %>
    </div>
    <form class="absolute w-0 h-0 opacity-0 pointer-events-none" autocomplete="off">
      <input
        id="card_id_input"
        name="card_id"
        type="text"
        autocomplete="off"
        aria-autocomplete="none"
        phx-change={JS.push("check_id") |> JS.dispatch("click", to: "#card_id_reset")}
        phx-hook="RingStatus"
        phx-mounted={JS.focus()}
        phx-blur={JS.focus()}
        phx-click-away={JS.focus()}
        phx-debounce="500"
      />
      <button id="card_id_reset" type="reset" />
    </form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("check_id", %{"card_id" => card_id}, socket) do
    case Accounts.get_user_by_card_id(card_id) do
      nil ->
        {:noreply, socket}

      user ->
        {:noreply, assign(socket, user: user)}
    end
  end

  def handle_event("close_user", _, socket), do: {:noreply, assign(socket, user: nil)}

  def handle_event("subtract-" <> num, _, socket) do
    {:ok, user} =
      Accounts.update_user(socket.assigns.user, %{
        tokens: socket.assigns.user.tokens - String.to_integer(num)
      })

    {:noreply, assign(socket, user: user)}
  end

  def handle_event("add-" <> num, _, socket) do
    {:ok, user} =
      Accounts.update_user(socket.assigns.user, %{
        tokens: socket.assigns.user.tokens + String.to_integer(num)
      })

    {:noreply, assign(socket, user: user)}
  end
end
