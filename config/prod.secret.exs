use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :interlineAPI, InterlineAPI.Endpoint,
  secret_key_base: "1PDl7CdC+GQOZ4+plyYG0xwX/JWol+i/sM3k9st+UhfGXpz8wcLSjuXL+addrG+f"

# Configure your database
config :interlineAPI, InterlineAPI.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "interlineAPI_prod"
