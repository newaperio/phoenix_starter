defmodule PhoenixStarter.Schema do
  @moduledoc """
  Base module `use`d by `Ecto.Schema` modules to set app defaults.
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime]
    end
  end
end
