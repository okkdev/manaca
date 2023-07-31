defmodule ManacaWeb.ApiAuthPlug do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    token = Application.get_env(:manaca, :api_token)

    case get_req_header(conn, "authorization") do
      ["Bearer " <> ^token] ->
        conn

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, ~S|{"status": "unauthorized"}|)
        |> halt()
    end
  end
end
