defmodule PhoenixStarter.Mailer do
  @moduledoc """
  Mailer to send emails with `Bamboo.Mailer`.
  """
  use Bamboo.Mailer, otp_app: :phoenix_starter

  @spec default_from :: Bamboo.Email.address()
  def default_from do
    Application.get_env(:phoenix_starter, __MODULE__)[:default_from]
  end
end
