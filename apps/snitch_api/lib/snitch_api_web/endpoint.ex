defmodule SnitchApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :snitch_api
  use Sentry.Phoenix.Endpoint

  alias Snitch.Core.Tools.MultiTenancy

  socket("/socket", SnitchApiWeb.UserSocket)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(
    Plug.Static,
    at: "/",
    from: :snitch_api,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(
    Plug.Session,
    store: :cookie,
    key: "_snitch_api_key",
    signing_salt: "39wcx/Xj"
  )

  plug(
    MultiTenancy.Plug,
    endpoint: __MODULE__
  )

  plug(ApiWeb.CORS)
  plug(SnitchApiWeb.Router)

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      config
      |> Keyword.put(:secret_key_base, System.fetch_env!("SECRET_KEY_BASE"))
      |> Keyword.put(:session_cookie_name, System.fetch_env!("SESSION_COOKIE_NAME"))
      |> Keyword.put(
        :session_cookie_signing_salt,
        System.fetch_env!("SESSION_COOKIE_SIGNING_SALT")
      )
      |> Keyword.put(
        :session_cookie_encryption_salt,
        System.fetch_env!("SESSION_COOKIE_ENCRYPTION_SALT")
      )

      port =
        System.get_env("API_PORT") || raise "expected the PORT environment variable to be set"

      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
