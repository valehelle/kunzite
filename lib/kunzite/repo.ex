defmodule Kunzite.Repo do
  use Ecto.Repo,
    otp_app: :kunzite,
    adapter: Ecto.Adapters.Postgres
end
