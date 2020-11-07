defmodule PhoenixStarter.Users.UserNotifier do
  @moduledoc """
  Delivers notifications to `PhoenixStarter.Users.User`s.
  """
  alias PhoenixStarter.Users.User
  alias PhoenixStarter.Users.UserEmail
  alias PhoenixStarter.Mailer

  @doc """
  Deliver instructions to confirm `PhoenixStarter.Users.User`.
  """
  @spec deliver_confirmation_instructions(User.t(), String.t()) :: Bamboo.Email.t()
  def deliver_confirmation_instructions(user, url) do
    user
    |> UserEmail.confirmation_instructions(url)
    |> Mailer.deliver_now()
  end

  @doc """
  Deliver instructions to reset a `PhoenixStarter.Users.User` password.
  """
  @spec deliver_reset_password_instructions(User.t(), String.t()) :: Bamboo.Email.t()
  def deliver_reset_password_instructions(user, url) do
    user
    |> UserEmail.reset_password_instructions(url)
    |> Mailer.deliver_now()
  end

  @doc """
  Deliver instructions to update a `PhoenixStarter.Users.User` email.
  """
  @spec deliver_update_email_instructions(User.t(), String.t()) :: Bamboo.Email.t()
  def deliver_update_email_instructions(user, url) do
    user
    |> UserEmail.update_email_instructions(url)
    |> Mailer.deliver_now()
  end
end
