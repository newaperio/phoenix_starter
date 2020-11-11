defmodule PhoenixStarter.Users.UserNotifier do
  @moduledoc """
  Delivers notifications to `PhoenixStarter.Users.User`s.
  """
  alias PhoenixStarter.Users.User
  alias PhoenixStarter.Users.UserEmail
  alias PhoenixStarter.Mailer
  alias PhoenixStarter.Workers.UserEmailWorker

  @type notifier_result ::
          {:ok, Bamboo.Email}
          | {:ok, Oban.Job.t()}
          | {:error, Oban.job_changeset()}
          | {:error, term()}

  @doc """
  Deliver instructions to confirm `PhoenixStarter.Users.User`.
  """
  @spec deliver_confirmation_instructions(User.t(), String.t(), boolean()) :: notifier_result
  def deliver_confirmation_instructions(user, url, async \\ true)

  def deliver_confirmation_instructions(user, url, true) do
    %{email: "confirmation_instructions", user_id: user.id, url: url}
    |> UserEmailWorker.new()
    |> Oban.insert()
  end

  def deliver_confirmation_instructions(user, url, false) do
    {:ok,
     user
     |> UserEmail.confirmation_instructions(url)
     |> Mailer.deliver_now()}
  end

  @doc """
  Deliver instructions to reset a `PhoenixStarter.Users.User` password.
  """
  @spec deliver_reset_password_instructions(User.t(), String.t(), boolean) :: notifier_result
  def deliver_reset_password_instructions(user, url, async \\ true)

  def deliver_reset_password_instructions(user, url, true) do
    %{email: "reset_password_instructions", user_id: user.id, url: url}
    |> UserEmailWorker.new()
    |> Oban.insert()
  end

  def deliver_reset_password_instructions(user, url, false) do
    {:ok,
     user
     |> UserEmail.reset_password_instructions(url)
     |> Mailer.deliver_now()}
  end

  @doc """
  Deliver instructions to update a `PhoenixStarter.Users.User` email.
  """
  @spec deliver_update_email_instructions(User.t(), String.t(), boolean) :: notifier_result
  def deliver_update_email_instructions(user, url, async \\ true)

  def deliver_update_email_instructions(user, url, true) do
    %{email: "update_email_instructions", user_id: user.id, url: url}
    |> UserEmailWorker.new()
    |> Oban.insert()
  end

  def deliver_update_email_instructions(user, url, false) do
    {:ok,
     user
     |> UserEmail.update_email_instructions(url)
     |> Mailer.deliver_now()}
  end
end
