defmodule ManacaWeb.UserController do
  use ManacaWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
