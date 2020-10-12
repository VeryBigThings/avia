import Config

config :pdf_generator, wkhtml_path: System.fetch_env!("WKHTML_PATH")

config :admin_app, AdminAppWeb.Mailer, api_key: System.fetch_env!("SENDGRID_API_KEY")
