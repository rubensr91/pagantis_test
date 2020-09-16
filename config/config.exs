# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pagantis,
  ecto_repos: [Pagantis.Repo]

# Configures the endpoint
config :pagantis, PagantisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ua6QrJyxUObsZPxOatQ77gIEbF8hjQDZQnXvK/qMAKXhOo6T4Vh9mISwLYjIDm5A",
  render_errors: [view: PagantisWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pagantis.PubSub,
  live_view: [signing_salt: "HHY2ltKw"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pagantis, :pow,
  user: Pagantis.Users.User,
  repo: Pagantis.Repo,
  web_module: PagantisWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
