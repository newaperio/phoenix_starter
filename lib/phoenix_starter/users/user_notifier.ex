defmodule PhoenixStarter.Users.UserNotifier do
  @moduledoc """
  Delivers notifications to `PhoenixStarter.Users.User`s.
  """
  use Phoenix.Swoosh, view: PhoenixStarterWeb.UserEmailView

  import PhoenixStarterWeb.Gettext

  alias PhoenixStarter.Users.User
  alias PhoenixStarter.Mailer
  alias PhoenixStarter.Email

  @doc """
  Deliver instructions to confirm `PhoenixStarter.Users.User`.
  """
  @spec deliver_confirmation_instructions(User.t(), String.t()) :: Email.notifier_result()
  def deliver_confirmation_instructions(user, url) do
    user
    |> base_email()
    |> subject(gettext("Confirm your account"))
    |> assign(:user, user)
    |> assign(:url, url)
    |> render_body(:confirmation_instructions)
    |> deliver()
  end

  @doc """
  Deliver instructions to reset a `PhoenixStarter.Users.User` password.
  """
  @spec deliver_reset_password_instructions(User.t(), String.t()) :: Email.notifier_result()
  def deliver_reset_password_instructions(user, url) do
    user
    |> base_email()
    |> subject(gettext("Reset your password"))
    |> assign(:user, user)
    |> assign(:url, url)
    |> render_body(:reset_password_instructions)
    |> deliver()
  end

  @doc """
  Deliver instructions to update a `PhoenixStarter.Users.User` email.
  """
  @spec deliver_update_email_instructions(User.t(), String.t()) :: Email.notifier_result()
  def deliver_update_email_instructions(user, url) do
    user
    |> base_email()
    |> subject(gettext("Confirm email change"))
    |> assign(:user, user)
    |> assign(:url, url)
    |> render_body(:update_email_instructions)
    |> deliver()
  end

  defp base_email(user) do
    new()
    |> from(PhoenixStarter.Email.default_from())
    |> to(user)
  end

  defp deliver(email) do
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
