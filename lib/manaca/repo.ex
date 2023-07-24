defmodule Manaca.Repo do
  use Ecto.Repo,
    otp_app: :manaca,
    adapter: Ecto.Adapters.SQLite3
end
