defmodule PhoenixStarter.Email do
  @moduledoc """
  Base Email module that includes helpers and other shared code.
  """

  @typedoc """
  A Swoosh-compatible recipient, being either:

  - A string representing an email address, like `foo.bar@example.com`
  - Or a two-element tuple `{name, address}`, where `name` is `nil` or a string
    and `address` is a string

  """
  @type recipient() :: String.t() | {String.t() | nil, String.t()}

  @doc """
  Returns a `t:recipient/0` that is the default from address for the app.
  """
  @spec default_from :: recipient
  def default_from do
    Application.get_env(:phoenix_starter, __MODULE__)[:default_from]
  end
end
