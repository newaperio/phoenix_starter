defmodule PhoenixStarter.Users.UserEmail do
  @moduledoc """
  Emails various notifications to `PhoenixStarter.Users.User`s.
  """
  use PhoenixStarter.Email
  use Bamboo.Phoenix, view: PhoenixStarterWeb.UserEmailView

  alias PhoenixStarter.Users.User
  alias PhoenixStarterWeb.LayoutView

  @spec confirmation_instructions(User.t(), String.t()) :: Bamboo.Email.t()
  def confirmation_instructions(user, url) do
    user
    |> base_email()
    |> subject(gettext("Confirm your account"))
    |> assign(:user, user)
    |> assign(:url, url)
    |> render(:confirmation_instructions)
  end

  @spec reset_password_instructions(User.t(), String.t()) :: Bamboo.Email.t()
  def reset_password_instructions(user, url) do
    user
    |> base_email()
    |> subject(gettext("Reset your password"))
    |> assign(:user, user)
    |> assign(:url, url)
    |> render(:reset_password_instructions)
  end

  @spec update_email_instructions(User.t(), String.t()) :: Bamboo.Email.t()
  def update_email_instructions(user, url) do
    user
    |> base_email()
    |> subject(gettext("Confirm email change"))
    |> assign(:user, user)
    |> assign(:url, url)
    |> render(:update_email_instructions)
  end

  defp base_email(admin) do
    new_email()
    |> to(admin)
    |> from(default_from())
    |> put_html_layout({LayoutView, "email.html"})
    |> put_text_layout({LayoutView, "email.text"})
  end
end
