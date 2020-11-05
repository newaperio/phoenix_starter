defmodule PhoenixStarter.Users.UserNotifier do
  @moduledoc """
  Delivers notifications to `PhoenixStarter.Users.User`s.
  """
  alias PhoenixStarter.Users.User

  # For simplicity, this module simply logs messages to the terminal.
  # You should replace it by a proper email or notification tool, such as:
  #
  #   * Swoosh - https://hexdocs.pm/swoosh
  #   * Bamboo - https://hexdocs.pm/bamboo
  #
  defp deliver(to, body) do
    require Logger
    Logger.debug(body)
    {:ok, %{to: to, body: body}}
  end

  @doc """
  Deliver instructions to confirm `PhoenixStarter.Users.User`.
  """
  @spec deliver_confirmation_instructions(User.t(), String.t()) :: {:ok, map}
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a `PhoenixStarter.Users.User` password.
  """
  @spec deliver_reset_password_instructions(User.t(), String.t()) :: {:ok, map}
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a `PhoenixStarter.Users.User` email.
  """
  @spec deliver_update_email_instructions(User.t(), String.t()) :: {:ok, map}
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
