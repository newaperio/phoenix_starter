defmodule PhoenixStarterWeb.Router do
  use PhoenixStarterWeb, :router

  import PhoenixStarterWeb.UserAuth
  import Phoenix.LiveDashboard.Router

  alias PhoenixStarterWeb.RequireUserPermission

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PhoenixStarterWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug PhoenixStarterWeb.ContentSecurityPolicy
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_ops_admin do
    plug :require_authenticated_user
    plug RequireUserPermission, permission: "ops.dashboard"
  end

  scope "/", PhoenixStarterWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/" do
    pipe_through [:browser, :require_ops_admin]

    live_dashboard "/dashboard",
      metrics: PhoenixStarterWeb.Telemetry,
      ecto_repos: [PhoenixStarter.Repo]
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  ## Authentication routes

  scope "/", PhoenixStarterWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", PhoenixStarterWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", PhoenixStarterWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
