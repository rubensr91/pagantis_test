defmodule Pagantis.Repo do
  use Ecto.Repo,
    otp_app: :pagantis,
    adapter: Ecto.Adapters.Postgres
end
