defmodule PhoenixStarter.Mailer do
  @moduledoc """
  Mailer to send emails with `Swoosh.Mailer`.
  """
  use Swoosh.Mailer, otp_app: :phoenix_starter
end
