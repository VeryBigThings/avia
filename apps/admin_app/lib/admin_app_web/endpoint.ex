defmodule AdminAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :admin_app
  use Sentry.Phoenix.Endpoint

  alias Snitch.Core.Tools.MultiTenancy

  socket("/socket", AdminAppWeb.UserSocket)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(
    Plug.Static,
    at: "/",
    from: :admin_app,
    gzip: true,
    only: ~w(css fonts images js favicon.png robots.txt)
  )

  # Serve the images saved in the upload folder.
  plug(Plug.Static, at: "/uploads", from: Path.expand('./uploads'), gzip: false)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
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
    key: "_admin_app_key",
    signing_salt: "yum1FuJK"
  )

  plug(
    MultiTenancy.Plug,
    endpoint: __MODULE__
  )

  plug(AdminAppWeb.Router)

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      config =
        config
        |> Keyword.put(:docs_url, System.fetch_env!("AVIA_DOCS"))
        |> Keyword.put(:password_reset_salt, System.fetch_env!("PASSWORD_RESET_SALT"))
        |> Keyword.put(:secret_key_base, System.fetch_env!("SECRET_KEY_BASE"))
        |> Keyword.put(:sendgrid_sender_mail, System.fetch_env!("SENDGRID_SENDER_EMAIL"))
        |> Keyword.put(
          :session_cookie_encryption_salt,
          System.fetch_env!("SESSION_COOKIE_ENCRYPTION_SALT")
        )
        |> Keyword.put(:session_cookie_name, System.fetch_env!("SESSION_COOKIE_NAME"))
        |> Keyword.put(
          :session_cookie_signing_salt,
          System.fetch_env!("SESSION_COOKIE_SIGNING_SALT")
        )
        |> Keyword.put(:support_url, System.fetch_env!("SUPPORT_URL"))
        |> Keyword.put(:token_maximum_age, System.fetch_env!("TOKEN_MAXIMUM_AGE"))
        |> Keyword.put(:url,
          host: System.fetch_env!("HOST"),
          port: System.fetch_env!("ADMIN_PORT")
        )

      port =
        System.get_env("ADMIN_PORT") ||
          raise "expected the ADMIN_PORT environment variable to be set"

      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
