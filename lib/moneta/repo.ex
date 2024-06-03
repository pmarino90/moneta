defmodule Moneta.Repo do
  use Ecto.Repo,
    otp_app: :moneta,
    adapter: Ecto.Adapters.SQLite3
end
