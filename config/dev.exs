use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :api, Api.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :api, Api.Repo,
  username: System.get_env("DB_UN"),
  password: System.get_env("DB_PW"),
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOST"),
  pool_size: 10

config :twilex,
  sid: System.get_env("TWILIO_SID"),
  token: System.get_env("TWILIO_TOKEN"),
  from_number: System.get_env("TWILIO_FROM_NUMBER"),
  flag_notify_number: System.get_env("TWILIO_FLAG_NOTIFY_NUMBER"),
  prod: false 

config :sentry,
  dsn: "https://cb399e24debb4b4f92bccd364abd1d3d:681da569b9bd41459ef08ea51ba60955@sentry.io/223754",
  enable_source_code_context: true,
  root_source_code_path: File.cwd!,
  included_environments: [:dev, :prod]
