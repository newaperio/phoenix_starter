defmodule PhoenixStarter.Users.UserEmail do
  @moduledoc """
  Emails various notifications to `PhoenixStarter.Users.User`s.
  """
  use Phoenix.Swoosh, view: PhoenixStarterWeb.UserEmailView

  import PhoenixStarterWeb.Gettext

  alias PhoenixStarter.Users.User

  @spec confirmation_instructions(User.t(), String.t()) :: Swoosh.Email.t()
  def confirmation_instructions(user, url) do
    user
    |> base_email()
    |> subject(gettext("Confirm your account"))
    |> assign(:user, user)
    |> assign(:url, url)
    |> render_body(:confirmation_instructions)
  end

  @spec reset_password_instructions(User.t(), String.t()) :: Swoosh.Email.t()
  def reset_password_instructions(user, url) do
    user
    |> base_email()
    |> subject(gettext("Reset your password"))
    |> assign(:user, user)
    |> assign(:url, url)
    |> render_body(:reset_password_instructions)
  end

  @spec update_email_instructions(User.t(), String.t()) :: Swoosh.Email.t()
  def update_email_instructions(user, url) do
    user
    |> base_email()
    |> subject(gettext("Confirm email change"))
    |> assign(:user, user)
    |> assign(:url, url)
    |> render_body(:update_email_instructions)
  end

  defp base_email(admin) do
    new()
    |> from(PhoenixStarter.Email.default_from())
    |> to(admin)
  end
end
