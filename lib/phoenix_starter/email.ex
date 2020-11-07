defmodule PhoenixStarter.Email do
  @moduledoc """
  Base Email module that includes helpers and other shared code.
  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import Bamboo.Email
      import PhoenixStarterWeb.Gettext
    end
  end

  @doc """
  Returns a `t:Bamboo.Email.address/0` tuple that is the default from address for the app.
  """
  @spec default_from :: Bamboo.Email.address()
  def default_from do
    Application.get_env(:phoenix_starter, __MODULE__)[:default_from]
  end
end
